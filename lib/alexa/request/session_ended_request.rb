# frozen_string_literal: true

require_relative '../request'
require_relative '../session'

module Alexa
  class Request
    class SessionEndedRequest < Alexa::Request
      attr_reader :session
      attr_reader :reason
      attr_reader :error

      def initialize(hash)
        super
        @session = Alexa::Session.new(hash[:session])
        @reason = hash[:request][:reason]
        @error = hash[:request][:error] if hash[:request][:error]
      end
    end
  end
end
