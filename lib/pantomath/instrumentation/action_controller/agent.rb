# frozen_string_literal: true

module Pantomath
  module Instrumentation
    module ActionController
      module Adapter
        def self.included(base)
          base.send(:around_action, :trace_request)
        end

        def trace_request(&block)
          tracer.trace(&block)
        end

        private
          def tracer
            Tracer.new(self)
          end

      end
    end
  end
end
