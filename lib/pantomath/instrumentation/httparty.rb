# frozen_string_literal: true

require "pantomath/instrumentation/httparty/adapter"
require "pantomath/instrumentation/httparty/tracer"

HTTParty::Request.send(:prepend, Pantomath::Instrumentation::HTTParty::Adapter)
