# frozen_string_literal: true

require "ostruct"

module Pantomath
  module Instrumentation
    module Sidekiq
      class Adapter

        def call(*args)
          tracer(*args).trace { yield }
        end

        private
          def tracer(worker, job, queue)
            context = OpenStruct.new(worker: worker, job: job, queue: queue)
            Tracer.new(context)
          end

      end
    end
  end
end
