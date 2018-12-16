# frozen_string_literal: true

module Pantomath
  module Instrumentation
    module HTTParty
      module Adapter

        def perform(&block)
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
