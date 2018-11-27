# frozen_string_literal: true

module Pantomath
  module Tracer
    module HTTParty

      def perform(&block)
        start_span
        super
      ensure
        close_span
      end

      def start_span
        Pantomath.tracer.start_active_span(
          span_name,
          tags: {
            "span.kind" => "external/http",
            "span.tracer" => "Pantomath::Tracer::HTTParty",
            "external.http.request.method" => http_method::METHOD,
            "external.http.request.host" => uri.host,
            "external.http.request.path" => uri.path
          }
        )
      end

      def close_span
        if Pantomath.active_scope
          Pantomath.active_span.set_tag("external.http.request.response_code", last_response.code.to_i)
          Pantomath.active_scope.close
        end
      end

      def span_name
        "NET/HTTP Call to #{uri.host}"
      end

    end
  end
end

HTTParty::Request.send(:prepend, Pantomath::Tracer::HTTParty)
