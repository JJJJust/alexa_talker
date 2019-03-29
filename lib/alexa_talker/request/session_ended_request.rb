# frozen_string_literal: true

require_relative '../request'
require_relative '../session'

module AlexaTalker
  class Request
    class SessionEndedRequest < AlexaTalker::Request
      attr_reader :session
      attr_reader :reason
      attr_reader :error

      def initialize(hash)
        super
        @session = AlexaTalker::Session.new(hash[:session])
        @reason = hash[:request][:reason]
        @error = hash[:request][:error] if hash[:request][:error]
      end
    end
  end
end
