# frozen_string_literal: true

require 'json'
require_relative 'speech'
require_relative 'session'
require_relative 'card'
require_relative 'response/directive'

module AlexaTalker
  class Response
    attr_accessor :version
    attr_reader :session
    attr_reader :speech_output
    attr_reader :card
    attr_reader :speech_reprompt
    attr_accessor :complete_session
    attr_reader :directives

    def initialize(**args)
      self.version = '1.0'
      args.each do |k, v|
        send("#{k}=", v)
      end
    end

    def session=(input)
      raise ArgumentError unless input.is_a?(AlexaTalker::Session) || input.nil?

      @session = input
    end

    def speech_output=(input)
      raise ArgumentError unless input.is_a?(AlexaTalker::Speech) || input.nil?

      @speech_output = input
    end

    def card=(input)
      raise ArgumentError unless input.is_a?(AlexaTalker::Card) || input.nil?
    end

    def speech_reprompt=(input)
      raise ArgumentError unless input.is_a?(AlexaTalker::Speech) || input.nil?

      @speech_reprompt = input
    end

    def directives=(input)
      raise ArgumentError unless input.is_a?(Array) || input.nil

      @directives = input
    end

    def to_json
      JSON.generate({ version: version,
                      sessionAttributes: session&.attributes,
                      response: response_objects_to_hash }.compact)
    end

    private

    def response_objects_to_hash
      { outputSpeech: speech_output&.to_response_h, card: card&.to_response_h,
        reprompt: reprompt_to_hash,
        shouldEndSession: complete_session,
        directives: directives_to_response_h }.compact
    end

    def reprompt_to_hash
      return nil if speech_reprompt.nil?

      { outputSpeech: speech_reprompt.to_response_h }.compact
    end

    def directives_to_response_h
      return nil if directives.nil? || directives.empty?

      array = []
      directives.each do |directive|
        result = directive&.to_response_h
        array << result if result
      end
      array
    end
  end
end
