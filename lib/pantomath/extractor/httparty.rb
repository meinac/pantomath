# frozen_string_literal: true

# Require this module to activate injecting trace_id by using HTTParty.
module Pantomath
  module Extractor
    module HTTParty
      module Request
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
end

HTTParty::Request.send(:prepend, Pantomath::Extractor::HTTParty::Request)
