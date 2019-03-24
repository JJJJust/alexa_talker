# frozen_string_literal: true

require_relative '../../intent'
require_relative 'dialog/confirm_intent'
require_relative 'dialog/confirm_slot'
require_relative 'dialog/delegate'
require_relative 'dialog/elicit_slot'

module Alexa
  class Response
    module Directive
      module Dialog
        attr_reader :type
        attr_reader :intent

        def intent=(input)
          raise ArgumentError unless input.is_a?(Alexa::Intent) || input.nil?

          @intent = input
        end
      end
    end
  end
end
