# frozen_string_literal: true

require "pantomath/instrumentation/action_controller/adapter"
require "pantomath/instrumentation/action_controller/tracer"

ActionController::Base.send(:include, Pantomath::Instrumentation::ActionController::Adapter)
