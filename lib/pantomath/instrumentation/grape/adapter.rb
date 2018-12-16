# frozen_string_literal: true

module Pantomath
  module Instrumentation
    module Grape
      module Adapter
        def run(env)
          @env = env
          @request = ::Grape::Request.new(env)

          tracer.trace { super }
        end

        private
          def tracer
            Tracer.new(self)
          end

      end
    end
  end
end
