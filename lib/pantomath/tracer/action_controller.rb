# frozen_string_literal: true

# Including this module into a contoller enables tracing for that controller.
# If you want to enable the controller tracing for whole project, include this
# module to ApplicationController.
module Pantomath
  module Tracer
    module ActionController

      def self.included(base)
        base.send(:around_action, :trace_request)
      end

      def trace_request
        start_span
        yield
        set_status
      ensure
        close_span
      end

      private
        def start_span
          Pantomath.tracer.start_active_span(
            span_name,
            child_of: tracer_context,
            tags: {
              "span.kind" => "web",
              "span.tracer" => "Pantomath::Tracer::ActionController",
              "http.request.method" => request.method,
              "http.request.url" => request.original_url,
              "http.request.path" => request.path,
              "action_controller.controller_name" => controller_name,
              "action_controller.action_name" => action_name
            }
          )
        end

        def span_name
          "#{request.method} #{request.original_url}"
        end

        def tracer_context
          Pantomath.extract(OpenTracing::FORMAT_RACK, request.env)
        end

        def close_span
          Pantomath.active_scope.close if Pantomath.active_scope
        end

        def set_status
          Pantomath.active_span.set_tag("http.response.status_code", status)
        end

    end
  end
end
