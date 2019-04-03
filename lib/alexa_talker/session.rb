# frozen_string_literal: true

module AlexaTalker
  class Session
    attr_reader :id
    attr_reader :attributes
    attr_reader :application_id

    def initialize(hash)
      @id = hash[:sessionId]
      @new = hash[:new]
      @attributes = hash[:attributes]
      @application_id = hash[:application][:applicationId]
    end

    def new?
      @new
    end
  end
end
