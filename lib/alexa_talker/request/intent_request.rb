# frozen_string_literal: true

require_relative '../request'
require_relative '../session'
require_relative '../intent'

module AlexaTalker
  class Request
    class IntentRequest < AlexaTalker::Request
      attr_reader :session
      attr_reader :dialog_state
      attr_reader :confirmation_status
      attr_reader :intent

      def initialize(hash)
        super
        @session = AlexaTalker::Session.new(hash[:session])
        @dialog_state = hash[:request][:dialogState]
        @intent = AlexaTalker::Intent.new(hash[:request][:intent])
      end
    end
  end
end
