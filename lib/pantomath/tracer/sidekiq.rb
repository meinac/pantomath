# frozen_string_literal: true

module Pantomath
  module Tracer
    class Sidekiq
      attr_reader :status

      def call(worker, job, queue)
        start_span(job, queue)
        @status = 'success'
        yield
      rescue Exception => e
        @status = 'error'
        raise e
      ensure
        close_span
      end

      private
        def start_span(job, queue)
          Pantomath.tracer.start_active_span(
            span_name(job['class']),
            child_of: tracer_context(job),
            tags: {
              "span.kind" => "async/worker",
              "span.tracer" => "Pantomath::Tracer::Sidekiq",
              "worker.queue" => queue,
              "worker.class" => job['class']
            }
          )
        end

        def span_name(job_name)
          "Async/Worker #{job_name}"
        end

        def tracer_context(job)
          Pantomath.extract(OpenTracing::FORMAT_TEXT_MAP, job)
        end

        def close_span
          if Pantomath.active_scope
            Pantomath.active_span.set_tag("status", status)
            Pantomath.active_scope.close
          end
        end

    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Pantomath::Tracer::Sidekiq
  end
end
