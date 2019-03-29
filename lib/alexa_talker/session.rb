# frozen_string_literal: true

module AlexaTalker
  class Session
    attr_reader :id
    attr_reader :attributes
    attr_reader :application_id

    def initialize(hash)
      @id = hash[:sessionId]
      @attributes = hash[:attributes]
      @application_id = hash[:application][:applicationId]
    end
  end
end
