# frozen_string_literal: true

require 'ostruct'

module Pantomath
  module Instrumentation
    module NetHTTP
      module Adapter

        def request(req, body = nil, &block)
          return tracer(req).trace { super } unless started?

          super
        end

        private
          def tracer(req)
            context = OpenStruct.new(http: self, req: req)
            Tracer.new(context)
          end

      end
    end
  end
end
