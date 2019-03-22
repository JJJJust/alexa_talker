# frozen_string_literal: true

module Alexa
  class Device
    attr_reader :id
    attr_reader :interfaces

    def initialize(hash)
      @id = hash[:deviceId]
      @interfaces = hash[:supportedInterfaces]
    end
  end
end
