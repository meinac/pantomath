# frozen_string_literal: true

require "pantomath/instrumentation/abstract_tracer"

module Pantomath
  module Instrumentation
    module ActionController
      class Tracer < AbstractTracer
        private
          def tags
            {
              "span.kind" => "web",
              "span.tracer" => "Pantomath::Tracer::ActionController",
              "http.request.method" => context.request.method,
              "http.request.url" => context.request.original_url,
              "http.request.path" => context.request.path,
              "action_controller.controller_name" => context.controller_name,
              "action_controller.action_name" => context.action_name
            }
          end

          def span_name
            "#{context.request.method} #{context.request.path}"
          end

          def tracer_context
            Pantomath.extract(OpenTracing::FORMAT_RACK, context.request.env)
          end

          def set_status
            Pantomath.active_span.set_tag("http.response.status_code", context.status) if Pantomath.active_span
          end

      end
    end
  end
end
