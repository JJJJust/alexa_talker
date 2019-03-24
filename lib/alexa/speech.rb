# frozen_string_literal: true

module Alexa
  class Speech
    attr_reader :type
    attr_accessor :output
    attr_reader :playback_behavior

    def initialize(**args)
      args.each do |k, v|
        send("#{k}=", v)
      end
    end

    def to_h
      { type: type, output: output, playbehavior: playback_behavior }
    end

    def to_response_h
      hash = to_h
      hash.merge!(output_to_h)
      raise ArgumentError, "'type' must be defined" unless type

      unless hash.key?(:ssml) || hash.key?(:text)
        raise ArgumentError, "'type' must be :ssml or :text"
      end

      hash.delete(:output)
      hash[:playBehavior] = hash.delete(:playback_behavior)
      hash
    end

    def type=(input)
      value = if input.nil? || input.empty?
                nil
              else
              input.to_sym.downcase
              end
      @type = value
    end

    def playback_behavior=(input)
      value = if input.nil? || input.empty?
                nil
              else
                input.to_sym.upcase
              end
      @playback_behavior = value
    end

    private

    def output_to_h
      case type
      when :ssml
        { ssml: output }
      when :text
        { text: output }
      else
        {}
      end
    end

  end
end
