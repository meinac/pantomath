# frozen_string_literal: true

require "spec_helper"
require "net/http"
require "pantomath/injector/net_http"

RSpec.describe Pantomath::Injector::NetHTTP do

  describe "injecting trace id to request headers" do
    context "when there is no active span" do
      before do
        stub_request(:get, "http://www.example.com:80/")
          .with(headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Ruby"
          })
          .to_return(status: 200, body: "", headers: {})
      end

      it "does not inject trace id into the headers of the http request" do
        response = Net::HTTP.get_response("www.example.com", "/")

        expect(response).to be_instance_of(Net::HTTPOK)
      end
    end

    context "when there is an active span" do
      let(:context) { double(:context) }
      let(:mock_span) { double(:span, context: context) }

      before do
        stub_request(:get, "http://www.example.com:80/")
          .with(headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Ruby",
            "Uber-Trace-Id" => "1:2:3:4"
          })
          .to_return(status: 200, body: "", headers: {})

        allow(TestTracer).to receive(:active_span).and_return(mock_span)
      end

      it "injects trace id into the headers of the http request" do
        response = Net::HTTP.get_response("www.example.com", "/")

        expect(response).to be_instance_of(Net::HTTPOK)
      end
    end
  end

end
