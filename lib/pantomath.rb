# frozen_string_literal: true

require "jaeger/client"
require "pantomath/version"
require "pantomath/configuration"

module Pantomath

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    block.call(configuration)
  end

  def self.tracer
    @tracer ||= begin
      Jaeger::Client.build(
        host: configuration.agent_host,
        port: configuration.agent_port,
        service_name: configuration.service_name
      )
    end
  end

end
