# frozen_string_literal: true

module Alexa
  class Intent
    attr_reader :name
    attr_reader :confirmation_status

    def initialize(hash)
      @name = hash[:name]
      @confirmation_status = hash[:confirmationStatus]
    end
  end
end
