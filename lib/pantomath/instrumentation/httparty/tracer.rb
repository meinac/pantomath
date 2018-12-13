# frozen_string_literal: true

require "pantomath/instrumentation/abstract_tracer"

module Pantomath
  module Instrumentation
    module HTTParty
      class Tracer < AbstractTracer
        private
          def tags
            {
              "span.kind" => "external/http",
              "span.tracer" => "Pantomath::Tracer::HTTParty",
              "external.http.request.method" => context.http_method::METHOD,
              "external.http.request.host" => context.uri.host,
              "external.http.request.path" => context.uri.path
            }
          end

          def span_name
            "NET/HTTP Call to #{context.uri.host}"
          end
      end
    end
  end
end
