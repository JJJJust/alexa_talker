# frozen_string_literal: true

require_relative '../dialog'

module AlexaTalker
  class Response
    module Directive
      module Dialog
        class Delegate
          include AlexaTalker::Response::Directive::Dialog

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

