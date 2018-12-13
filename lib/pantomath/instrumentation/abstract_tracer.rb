# frozen_string_literal: true

module Pantomath
  module Instrumentation
    class AbstractTracer

      class << self
        def tag_collector
          Pantomath.configuration.tag_collectors.send(config_name)
        end

        private
          def config_name
            @config_name ||= group_name.gsub(/([a-z\d])([A-Z])/,"\1_\2").downcase
          end

          def group_name
            name.split("::")[2]
          end

      end

      attr_reader :context

      def initialize(context)
        @context = context
      end

      def trace
        start_span
        result = yield
        set_status
        result
      ensure
        close_span
      end

      private
        def start_span
          Pantomath.tracer.start_active_span(
            span_name,
            child_of: tracer_context,
            tags: span_tags
          )
        end

        def span_name
          raise "Should be implemented"
        end

        def tags
          raise "Should be implemented"
        end

        def tracer_context; end

        def set_status; end

        def close_span
          Pantomath.active_scope.close if Pantomath.active_scope
        end

        def span_tags
          tags.merge!(collected_tags)
        end

        def collected_tags
          return {} unless tag_collector

          tag_collector.is_a?(Proc) ? context.instance_exec(&tag_collector) : context.send(tag_collector)
        end

        def tag_collector
          self.class.tag_collector
        end

    end
  end
end
