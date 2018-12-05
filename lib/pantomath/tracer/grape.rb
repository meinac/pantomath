# frozen_string_literal: true

module Pantomath
  module Tracer
    module Grape

      def inherited(child)
        super
        define_tracer_callbacks(child)
      end

      def define_tracer_callbacks(child)
        return unless namespace_stackable(:tracer_callbacks_defined).blank?
        namespace_stackable(:tracer_callbacks_defined, true)

        child.send(:before, &:start_span)
        child.send(:after, &:close_span)

        child.send(:helpers) do
          def start_span
            Pantomath.tracer.start_active_span(
              span_name,
              child_of: tracer_context,
              ignore_active_scope: true,
              tags: {
                "span.kind" => "web",
                "span.tracer" => "Pantomath::Tracer::Grape",
                "http.request.method" => route.route_method,
                "http.request.url" => request.url,
                "http.request.path" => request.path,
                "grape.route.version" => route.route_version,
                "grape.route.path" => route.route_path
              }
            )
          end

          def close_span
            if Pantomath.active_scope
              Pantomath.active_span.set_tag("http.response.status_code", @status)
              Pantomath.active_scope.close
            end
          end

          def span_name
            "#{request.env['REQUEST_METHOD']} #{request.path}"
          end

          def tracer_context
            Pantomath.extract(OpenTracing::FORMAT_RACK, request.env)
          end
        end
      end

    end
  end
end

Grape::API.singleton_class.send(:prepend, Pantomath::Tracer::Grape)
