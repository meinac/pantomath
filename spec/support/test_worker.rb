# frozen_string_literal: true

class TestWorker
  include Sidekiq::Worker

  def perform(*args); end

end
