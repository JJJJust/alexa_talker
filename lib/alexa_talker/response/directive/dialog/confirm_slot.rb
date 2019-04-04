# frozen_string_literal: true

require_relative '../../../slot'
require_relative '../dialog'

module AlexaTalker
  class Response
    module Directive
      module Dialog
        class ConfirmSlot
          include AlexaTalker::Response::Directive::Dialog

          attr_reader :slot

          def initialize
            @type = 'Dialog.ConfirmSlot'
          end

          def slot=(input)
            @slot = if input.is_a?(AlexaTalker::Slot)
                      input.name
                    else
                      input
                    end
          end

          def to_response_h
            { type: type, slotToConfirm: slot, updatedIntent: intent }.compact
          end
        end
      end
    end
  end
end
