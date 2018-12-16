# frozen_string_literal: true

require "pantomath/instrumentation/sidekiq/adapter"
require "pantomath/instrumentation/sidekiq/tracer"

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Pantomath::Instrumentation::Sidekiq::Adapter
  end
end
