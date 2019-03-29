# frozen_string_literal: true

require 'json'
require 'time'
require_relative 'device'
require_relative 'request/launch_request'
require_relative 'request/intent_request'
require_relative 'request/session_ended_request'
require_relative 'request/validator'

module AlexaTalker
  class Request
    attr_reader :version
    attr_reader :id
    attr_reader :time
    attr_reader :locale
    attr_reader :device
    attr_reader :user_id
    attr_reader :user_access_token

    def initialize(hash)
      @version = hash[:version]
      request_handler(hash[:request])
      system_handler(hash[:context][:System])
    end

    def self.parse(input)
      raise TypeError unless input.is_a?(String)

      json_hash = JSON.parse(input, symbolize_names: true)
      request_type = json_hash[:request][:type].to_s
      Object.const_get('AlexaTalker::Request::' + request_type).new(json_hash)
    end

    private

    def request_handler(request_hash)
      @id = request_hash[:requestId]
      @time = Time.parse(request_hash[:timestamp])
      @locale = request_hash[:locale]
      nil
    end

    def system_handler(system_hash)
      @application_id = system_hash[:application][:applicationId]
      @api_access_token = system_hash[:apiAccessToken]
      @api_endpoint = system_hash[:apiEndpoint]
      @device = AlexaTalker::Device.new(system_hash[:device])
      @user_id = system_hash[:user][:userId]
      if system_hash[:user][:accessToken]
        @user_access_token = system_hash[:user][:accessToken]
      end
      nil
    end
  end
end
