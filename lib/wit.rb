# Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.

require 'json'
require 'logger'
require 'net/http'
require 'securerandom'

class Wit
  class Error < StandardError; end

  WIT_API_HOST = ENV['WIT_URL'] || 'https://api.wit.ai'
  WIT_API_VERSION = ENV['WIT_API_VERSION']  || '20160516'
  DEFAULT_MAX_STEPS = 5
  LEARN_MORE = 'Learn more at https://wit.ai/docs/quickstart'

  def initialize(opts = {})
    @access_token = opts[:access_token]

    if opts[:logger]
      @logger = opts[:logger]
    end
  end

  def logger
    @logger ||= begin
      x = Logger.new(STDOUT)
      x.level = Logger::INFO
      x
    end
  end

  def message(msg, n=nil, verbose=nil)
    params = {}
    params[:q] = msg unless msg.nil?
    params[:n] = n unless n.nil?
    params[:verbose] = verbose unless verbose.nil?
    res = req(logger, @access_token, Net::HTTP::Get, '/message', params)
    return res
  end

  def interactive(handle_message=nil, context={})
    while true
      print '> '
      msg = STDIN.gets.strip
      if msg == ''
        next
      end

      begin
        if handle_message.nil?
          puts(message(msg))
        else
          puts(handle_message.call(message(msg)))
        end
      rescue Error => exp
        logger.error("error: #{exp.message}")
      end
    end
  rescue Interrupt => _exp
    puts
  end

  def get_entities
    req(logger, @access_token, Net::HTTP::Get, "/entities")
  end

  def post_entities(payload)
    payload = payload.map {|k, v| [(k.to_sym rescue k), v]}.to_h.reject{ |k| ![:id, :doc, :values, :lookups].include?(k) }
    validate_payload payload
    req(logger, @access_token, Net::HTTP::Post, "/entities", {}, payload)
  end

  def get_entity(entity_id)
    req(logger, @access_token, Net::HTTP::Get, "/entities/#{URI.encode(entity_id)}")
  end

  def put_entities(entity_id, payload)
    payload = payload.map {|k, v| [(k.to_sym rescue k), v]}.to_h.reject{ |k| ![:id, :doc, :values].include?(k) }
    validate_payload payload
    req(logger, @access_token, Net::HTTP::Put, "/entities/#{URI.encode(entity_id)}", {}, payload)
  end

  def delete_entities(entity_id)
    req(logger, @access_token, Net::HTTP::Delete, "/entities/#{URI.encode(entity_id)}")
  end

  def post_values(entity_id, payload)
    payload = payload.map {|k, v| [(k.to_sym rescue k), v]}.to_h.reject{ |k| ![:value, :expressions, :metadata].include?(k) }
    validate_payload payload
    req(logger, @access_token, Net::HTTP::Post, "/entities/#{URI.encode(entity_id)}/values", {}, payload)
  end

  def delete_values(entity_id, value)
    req(logger, @access_token, Net::HTTP::Delete, "/entities/#{URI.encode(entity_id)}/values/#{URI.encode(value)}")
  end

  def post_expressions(entity_id, value, payload)
    payload = payload.map {|k, v| [(k.to_sym rescue k), v]}.to_h.reject{ |k| ![:expression].include?(k) }
    validate_payload payload
    req(logger,@access_token, Net::HTTP::Post, "/entities/#{URI.encode(entity_id)}/values/#{URI.encode(value)}/expressions", {}, payload)
  end

  def delete_expressions(entity_id, value, expression)
    req(logger,@access_token, Net::HTTP::Delete, "/entities/#{URI.encode(entity_id)}/values/#{URI.encode(value)}/expressions/#{URI.encode(expression)}")
  end

  private

  def validate_payload(payload)
    key_types = {
      id: String,
      doc: String,
      value: String,
      values: Array,
      lookups: Array,
      expression: String,
      expressions: Array,
      metadata: String,
    }
    payload.each do |k, v|
      raise Error.new("#{k.to_s} in request body must be #{key_types[k].to_s} type") unless key_types[k] == v.class
    end
  end

  class EntityAlreadyExists < Error
  end

  def req(logger, access_token, meth_class, path, params={}, payload={})
    uri = URI(WIT_API_HOST + path)
    uri.query = URI.encode_www_form(params)

    logger.debug("#{meth_class} #{uri}")

    request = meth_class.new(uri)
    request['authorization'] = 'Bearer ' + access_token
    request['accept'] = 'application/vnd.wit.' + WIT_API_VERSION + '+json'
    request.add_field 'Content-Type', 'application/json'
    request.body = payload.to_json


    Net::HTTP.start(uri.host, uri.port, {:use_ssl => uri.scheme == 'https'}) do |http|
      rsp = http.request(request)
      if rsp.body =~ /An entity with this name already exists/
        raise EntityAlreadyExists.new
      end

      if rsp.code.to_i != 200
        raise Error.new("HTTP error code=#{rsp.code}")
      end
      json = JSON.parse(rsp.body)
      if json.is_a?(Hash) and json.has_key?('error')
        raise Error.new("Wit responded with an error: #{json['error']}")
      end
      logger.debug("#{meth_class} #{uri} #{json}")
      json
    end
  end
end
