module Wit
  require 'json'
  require 'net/http'

  WIT_API_HOST = ENV['WIT_URL'] || 'https://api.wit.ai'

  class WitException < Exception
  end

  def self.req(access_token, meth_class, path, params)
    uri = URI(WIT_API_HOST + path)
    uri.query = URI.encode_www_form(params)

    req = meth_class.new(uri)
    req['authorization'] = 'Bearer ' + access_token
    req['accept'] = 'application/vnd.wit.20160330+json'

    Net::HTTP.start(
      uri.host, uri.port, :use_ssl => uri.scheme == 'https'
    ) do |http|
      rsp = http.request(req)
      if rsp.code.to_i > 200
        raise WitException.new('HTTP error code=' + rsp.code)
      end

      JSON.parse(rsp.body)
    end
  end

  def self.message(access_token, msg)
    params = {}
    if msg
      params[:q] = msg
    end
    req(access_token, Net::HTTP::Get, '/message', params)
  end
end
