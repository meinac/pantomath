# frozen_string_literal: true

require "pantomath/instrumentation/action_controller/agent"
require "pantomath/instrumentation/action_controller/tracer"

ActionController::Base.send(:include, Pantomath::Instrumentation::ActionController::Adapter)
