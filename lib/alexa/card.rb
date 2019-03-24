# frozen_string_literal: true

module Alexa
  class Card
    attr_reader :type
    attr_accessor :title
    attr_accessor :text
    attr_accessor :image_small
    attr_accessor :image_large

    def type=(input)
      value = if input.nil? || input.empty?
                nil
              else
                input.to_sym
              end
      @type = value
    end

    def to_response_h
      hash = { type: type }
      hash.merge!(output_to_h)
      hash[:content] = hash.delete(:text) if type == :Simple
      if hash[:image]
        hash[:image][:smallImageUrl] = hash[:image].delete(:image_small)
        hash[:image][:largeImageUrl] = hash[:image].delete(:image_large)
        hash[:image].compact!
      end
      hash.compact
    end

    private

    def output_to_h
      hash = case type
             when :Simple
               { title: title, text: text }
             when :Standard
               { title: title, text: text, image: image_to_h }
             else
               {}
             end
      hash.compact
    end

    def image_to_h
      return nil unless image_small || image_large

      { image_small: image_small, image_large: image_large }.compact
    end
  end
end
