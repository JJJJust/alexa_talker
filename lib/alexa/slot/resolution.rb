# frozen_string_literal: true

module Alexa
  class Slot
    class Resolution
      attr_reader :authority
      attr_reader :status
      attr_reader :values

      def initialize(hash)
        @authority = hash[:authority]
        @status = hash[:status][:code]
        @values = values_handler(hash[:values]) if hash[:values]
      end

      private

      def values_handler(array)
        result = []
        array.each do |hash|
          result << hash[:value]
        end
        result
      end
    end
  end
end
