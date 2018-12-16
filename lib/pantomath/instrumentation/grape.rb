# frozen_string_literal: true

require "pantomath/instrumentation/grape/adapter"
require "pantomath/instrumentation/grape/tracer"

Grape::Endpoint.send(:prepend, Pantomath::Instrumentation::Grape::Adapter)
