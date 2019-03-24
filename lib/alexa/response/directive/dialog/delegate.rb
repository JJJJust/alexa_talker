# frozen_string_literal: true

require_relative '../dialog'

module Alexa
  class Response
    module Directive
      module Dialog
        class Delegate
          include Alexa::Response::Directive::Dialog

          def initialize
            @type = 'Dialog.Delegate'
          end

          def to_response_h
            { type: type, updatedIntent: intent }.compact
          end
        end
      end
    end
  end
end

