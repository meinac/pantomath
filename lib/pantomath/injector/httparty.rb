# frozen_string_literal: true

module Pantomath
  module Injector
    module HTTParty
      def initialize(http_method, path, options = {})
        options[:headers] ||= {}
        inject_trace_id(options[:headers])

        super(http_method, path, options)
      end

      private
        def inject_trace_id(headers)
          Pantomath.inject(OpenTracing::FORMAT_RACK, headers)
        end

    end
  end
end

HTTParty::Request.send(:prepend, Pantomath::Injector::HTTParty)
