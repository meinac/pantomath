# frozen_string_literal: true

require "pantomath/instrumentation/grape/agent"
require "pantomath/instrumentation/grape/tracer"

Grape::Endpoint.send(:prepend, Pantomath::Instrumentation::Grape::Adapter)
