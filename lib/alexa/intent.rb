# frozen_string_literal: true

require_relative 'slot'

module Alexa
  class Intent
    attr_reader :name
    attr_reader :confirmation_status
    attr_reader :slots

    def initialize(hash)
      @name = hash[:name]
      @confirmation_status = hash[:confirmationStatus]
      @slots = slot_handler(hash[:slots]) if hash.key?(:slots)
    end

    private

    def slot_handler(hash)
      return [] if hash.empty?

      result = []
      hash.each do |_k, v|
        result << Alexa::Slot.new(v)
      end
      result
    end
  end
end
