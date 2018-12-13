# frozen_string_literal: true

require "pantomath/instrumentation/abstract_tracer"

module Pantomath
  module Instrumentation
    module Grape
      class Tracer < AbstractTracer
        private
          def tags
            {
              "span.kind" => "web",
              "span.tracer" => "Pantomath::Tracer::Grape",
              "http.request.method" => context.route.route_method,
              "http.request.url" => context.request.url,
              "http.request.path" => context.request.path,
              "grape.route.version" => context.route.route_version,
              "grape.route.path" => context.route.route_path
            }
          end

          def span_name
            "#{context.request.env['REQUEST_METHOD']} #{context.request.path}"
          end

          def tracer_context
            Pantomath.extract(OpenTracing::FORMAT_RACK, context.request.env)
          end
      end
    end
  end
end
