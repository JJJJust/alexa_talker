# frozen_string_literal: true

require_relative '../../../slot'
require_relative '../dialog'

module AlexaTalker
  class Response
    module Directive
      module Dialog
        class ElicitSlot
          include AlexaTalker::Response::Directive::Dialog

          attr_reader :slot

          def initialize
            @type = 'Dialog.ElicitSlot'
          end

          def slot=(input)
            @slot = if input.is_a?(AlexaTalker::Slot)
                      input.name
                    else
                      input
                    end
          end

          def to_response_h
            { type: type, slotToElicit: slot, updatedIntent: intent }.compact
          end
        end
      end
    end
  end
end
