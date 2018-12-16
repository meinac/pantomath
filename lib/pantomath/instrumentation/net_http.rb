# frozen_string_literal: true

require "pantomath/instrumentation/net_http/adapter"
require "pantomath/instrumentation/net_http/tracer"

Net::HTTP.send(:prepend, Pantomath::Instrumentation::NetHTTP::Adapter)
