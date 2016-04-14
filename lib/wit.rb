require 'json'
require 'logger'
require 'net/http'

WIT_API_HOST = ENV['WIT_URL'] || 'https://api.wit.ai'
DEFAULT_MAX_STEPS = 5

class WitException < Exception
end

def req(access_token, meth_class, path, params={}, payload={})
  uri = URI(WIT_API_HOST + path)
  uri.query = URI.encode_www_form params

  request = meth_class.new uri
  request['authorization'] = 'Bearer ' + access_token
  request['accept'] = 'application/vnd.wit.20160330+json'
  request.add_field 'Content-Type', 'application/json'
  request.body = payload.to_json

  Net::HTTP.start uri.host, uri.port, {:use_ssl => uri.scheme == 'https'} do |http|
    rsp = http.request request
    raise WitException.new "HTTP error code=#{rsp.code}" unless rsp.code.to_i <= 200
    json = JSON.parse rsp.body
    raise WitException.new "Wit responded with an error: #{json['error']}" if json.has_key? 'error'
    json
  end
end

def validate_actions(actions)
  learn_more = 'Learn more at https://wit.ai/docs/quickstart'
  raise WitException.new 'The second parameter should be a Hash' unless actions.is_a? Hash
  [:say, :merge, :error].each do |action|
    raise WitException.new "The #{action} action is missing. #{learn_more}" unless actions.has_key? action
  end
  actions.each_pair do |k, v|
    raise WitException.new "The '#{k}' action name should be a symbol" unless k.is_a? Symbol
    raise WitException.new "The '#{k}' action should be a lambda function" unless v.respond_to? :call and v.lambda?
    raise WitException.new "The \'say\' action should take 2 arguments: session_id, msg. #{learn_more}" if k == :say and v.arity != 2
    raise WitException.new "The \'merge\' action should take 2 arguments: context, entities. #{learn_more}" if k == :merge and v.arity != 2
    raise WitException.new "The \'error\' action should take 2 arguments: session_id, msg. #{learn_more}" if k == :error and v.arity != 2
    raise WitException.new "The '#{k}' action should take 1 argument: context. #{learn_more}" if k != :say and k != :merge and k != :error and v.arity != 1
  end
  return actions
end

class Wit
  class << self
    attr_writer :logger

    def logger
      @logger ||= begin
        $stdout.sync = true
        Logger.new(STDOUT)
      end.tap { |logger| logger.level = Logger::INFO }
    end
  end

  def initialize(access_token, actions)
    @access_token = access_token
    @actions = validate_actions actions
  end

  def logger
    self.class.logger
  end

  def message(msg)
    params = {}
    params[:q] = msg unless msg.nil?
    req @access_token, Net::HTTP::Get, '/message', params
  end

  def converse(session_id, msg, context={})
    params = {}
    params[:q] = msg unless msg.nil?
    params[:session_id] = session_id
    req @access_token, Net::HTTP::Post, '/converse', params, context
  end

  def run_actions(session_id, message, context={}, max_steps=DEFAULT_MAX_STEPS)
    raise WitException.new 'max iterations reached' unless max_steps > 0

    rst = converse session_id, message, context
    raise WitException.new 'couldn\'t find type in Wit response' unless rst.has_key? 'type'

    type = rst['type']

    return context if type == 'stop'
    if type == 'msg'
      raise WitException.new 'unknown action: say' unless @actions.has_key? :say
      msg = rst['msg']
      logger.info "Executing say with: #{msg}"
      @actions[:say].call session_id, msg
    elsif type == 'merge'
      raise WitException.new 'unknown action: merge' unless @actions.has_key? :merge
      logger.info 'Executing merge'
      context = @actions[:merge].call context, rst['entities']
      if context.nil?
        logger.warn 'missing context - did you forget to return it?'
        context = {}
      end
    elsif type == 'action'
      action = rst['action'].to_sym
      raise WitException.new "unknown action: #{action}" unless @actions.has_key? action
      logger.info "Executing action #{action}"
      context = @actions[action].call context
      if context.nil?
        logger.warn 'missing context - did you forget to return it?'
        context = {}
      end
    elsif type == 'error'
      raise WitException.new 'unknown action: error' unless @actions.has_key? :error
      logger.info 'Executing error'
      @actions[:error].call session_id, 'unknown action: error'
    else
      raise WitException.new "unknown type: #{type}"
    end
    return run_actions session_id, nil, context, max_steps - 1
  end
end
