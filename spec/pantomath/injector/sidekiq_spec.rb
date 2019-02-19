# frozen_string_literal: true

require "spec_helper"
require "sidekiq"
require "pantomath/injector/sidekiq"

RSpec.describe Pantomath::Injector::Sidekiq do

  describe "injecting trace id to job" do
    subject { TestWorker.perform_async }

    let(:job) { TestWorker.jobs.first }
    let(:injected_trace_id) { job["Uber-Trace-Id"] }
    let(:expected_trace_id) { "1:2:3:4" }

    before { TestWorker.drain }

    context "when there is no active span" do
      it "does not inject trace id to job" do
        subject

        expect(injected_trace_id).to be_nil
      end
    end

    context "when there is an active span" do
      let(:context) { double(:context) }
      let(:mock_span) { double(:span, context: context) }

      before do
        allow(TestTracer).to receive(:active_span).and_return(mock_span)
      end

      it "injects trace id to job" do
        subject

        expect(injected_trace_id).to eql(expected_trace_id)
      end
    end
  end

end
