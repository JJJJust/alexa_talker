# frozen_string_literal: true

require_relative 'slot'

module Alexa
  class Intent
    attr_accessor :name
    attr_accessor :confirmation_status
    attr_reader :slots

    def initialize(**hash)
      @name = hash[:name]
      @confirmation_status = hash[:confirmationStatus]
      @slots = slot_handler(hash[:slots])
    end

    def slots=(input)
      raise ArgumentError unless input.is_a?(Array) || input.nil?

      @slots = input
    end

    def to_json
      { name: name, confirmationStatus: confirmation_status,
        slots: slot_hash_handler }
        .compact
    end

    private

    def slot_handler(hash)
      return nil unless hash

      result = []
      hash.each do |_k, v|
        result << Alexa::Slot.new(v)
      end
      result
    end

    def slot_hash_handler
      return [] unless slots

      return [] if slots.empty?

      output = {}
      slots.each do |slot|
        output.merge!(slot.name.to_sym => slot.to_json)
      end
      output
    end
  end
end
