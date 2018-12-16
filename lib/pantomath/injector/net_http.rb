# frozen_string_literal: true

module Pantomath
  module Injector
    module NetHTTP

      def initialize(path, initheader = nil)
        headers = prepare_headers(initheader)

        super(path, headers)
      end

      def initialize_http_header(initheader)
        headers = prepare_headers(initheader)

        super(headers)
      end

      private
        def prepare_headers(initheader)
          headers = initheader ? initheader.dup : {}
          inject_trace_id(headers)
          headers
        end

        def inject_trace_id(headers)
          Pantomath.inject(OpenTracing::FORMAT_RACK, headers)
        end

    end
  end
end

Net::HTTPRequest.send(:prepend, Pantomath::Injector::NetHTTP)
