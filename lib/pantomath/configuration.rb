# frozen_string_literal: true

require "ostruct"

module Pantomath
  class Configuration
    attr_accessor :agent_host, :agent_port, :service_name

    def tag_collectors
      @tag_collectors ||= OpenStruct.new
    end
  end
end
