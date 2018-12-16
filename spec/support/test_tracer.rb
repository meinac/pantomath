class TestTracer

  class << self

    def scope_manager; end
    def active_span; end

    def inject(span_context, format, carrier)
      carrier["Uber-Trace-Id"] = "1:2:3:4"
    end

  end

end
