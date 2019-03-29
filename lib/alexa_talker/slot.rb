# frozen_string_literal: true

require_relative 'slot/resolution'

module AlexaTalker
  class Slot
    attr_reader :name
    attr_reader :value
    attr_reader :confirmation_status
    attr_reader :resolutions

    def initialize(hash)
      @name = hash[:name]
      @value = hash[:value]
      @confirmation_status = hash[:confirmationStatus]
      @resolutions = if hash.key?(:resolutions)
                       resolution_handler(
                         hash[:resolutions][:resolutionsPerAuthority]
                       )
                     end
    end

    private

    def resolution_handler(array)
      result = []
      array.each do |hash|
        result << AlexaTalker::Slot::Resolution.new(hash)
      end
      result
    end
  end
end
