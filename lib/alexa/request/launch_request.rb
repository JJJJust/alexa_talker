# frozen_string_literal: true

require_relative '../request'
require_relative '../session'

module Alexa
  class Request
    class LaunchRequest < Alexa::Request
      attr_reader :session

      def initialize(hash)
        super
        @session = Alexa::Session.new(hash[:session])
      end
    end
  end
end
