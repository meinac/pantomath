# frozen_string_literal: true

require "spec_helper"
require "httparty"
require "pantomath/injector/httparty"

RSpec.describe Pantomath::Injector::HTTParty do

  describe "injecting trace id to request headers" do
    context "when there is no active span" do
      before do
        stub_request(:get, "https://www.example.com/")
          .with(headers: {})
          .to_return(status: 200, body: "", headers: {})
      end

      it "does not inject trace id into the headers of the http request" do
        response = HTTParty.get("https://www.example.com")

        expect(response).to be_ok
      end
    end

    context "when there is an active span" do
      let(:context) { double(:context, trace_id: 1, span_id: 2, parent_id: 3, flags: 4) }
      let(:mock_span) { double(:span, context: context) }

      before do
        stub_request(:get, "https://www.example.com/")
          .with(headers: { 'Uber-Trace-Id'=>'1:2:3:4' })
          .to_return(status: 200, body: "", headers: {})

        allow(Pantomath).to receive(:active_span).and_return(mock_span)
      end

      it "injects trace id into the headers of the http request" do
        response = HTTParty.get("https://www.example.com")

        expect(response).to be_ok
      end
    end
  end

end
