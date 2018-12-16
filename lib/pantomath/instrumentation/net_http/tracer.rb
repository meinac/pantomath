# frozen_string_literal: true

require "pantomath/instrumentation/abstract_tracer"

module Pantomath
  module Instrumentation
    module NetHTTP
      class Tracer < AbstractTracer
        private
          def tags
            {
              "span.kind" => "external/http",
              "span.tracer" => "Pantomath::Tracer::NetHTTP",
              "external.http.request.method" => context.req.method,
              "external.http.request.host" => context.http.address,
              "external.http.request.port" => context.http.port,
              "external.http.request.path" => context.req.path
            }
          end

          def span_name
            "NET/HTTP Call to #{context.http.address}"
          end
      end
    end
  end
end
