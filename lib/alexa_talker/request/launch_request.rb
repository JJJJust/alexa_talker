# frozen_string_literal: true

require_relative '../request'
require_relative '../session'

module AlexaTalker
  class Request
    class LaunchRequest < AlexaTalker::Request
      attr_reader :session

      def initialize(hash)
        super
        @session = AlexaTalker::Session.new(hash[:session])
      end
    end
  end
end
