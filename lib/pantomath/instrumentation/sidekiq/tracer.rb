# frozen_string_literal: true

require "pantomath/instrumentation/abstract_tracer"

module Pantomath
  module Instrumentation
    module Sidekiq
      class Tracer < AbstractTracer
        private
          def tags
            {
              "span.kind" => "async/worker",
              "span.tracer" => "Pantomath::Tracer::Sidekiq",
              "worker.queue" => context.queue,
              "worker.class" => context.job["class"]
            }
          end

          def span_name
            "Async/Worker #{context.job['class']}"
          end

          def tracer_context
            Pantomath.extract(OpenTracing::FORMAT_TEXT_MAP, context.job)
          end

      end
    end
  end
end
