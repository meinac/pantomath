# frozen_string_literal: true

module Pantomath
  module Injector
    class Sidekiq
      def call(worker_class, job, queue, redis_pool)
        inject_trace_id(job)
        yield
      end

      private
        def inject_trace_id(job)
          Pantomath.inject(OpenTracing::FORMAT_TEXT_MAP, job)
        end

    end
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Pantomath::Injector::Sidekiq
  end
end

Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    chain.add Pantomath::Injector::Sidekiq
  end
end

