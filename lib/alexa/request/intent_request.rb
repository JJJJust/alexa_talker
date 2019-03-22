# frozen_string_literal: true

require_relative '../request'
require_relative '../session'
require_relative '../intent'
require_relative '../slot'

module Alexa
  class Request
    class IntentRequest < Alexa::Request
      attr_reader :session
      attr_reader :dialog_state
      attr_reader :confirmation_status
      attr_reader :intent
      attr_reader :slots

      def initialize(hash)
        super
        @session = Alexa::Session.new(hash[:session])
        @dialog_state = hash[:request][:dialogState]
        @intent = Alexa::Intent.new(hash[:request][:intent])
        @slots = slot_handler(hash[:request][:intent][:slots])
      end

      private

      def slot_handler(hash)
        result = []
        unless hash.empty?
          hash.each do |_k, v|
            result << Alexa::Slot.new(v)
          end
        end
        result
      end
    end
  end
end
