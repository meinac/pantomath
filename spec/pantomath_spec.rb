# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pantomath do
  describe "::configuration" do
    subject { described_class.configuration }

    it { is_expected.to be_instance_of(Pantomath::Configuration) }
  end

  describe "::configure" do
    let(:configuration) { described_class.configuration }

    subject { described_class.configure { |c| c.service_name = :foo } }

    it "calls the given block with configuration" do
      expect { subject }.to change { configuration.service_name }.to(:foo)
    end
  end

  describe "::tracer" do
    subject { described_class.tracer }

    it { is_expected.to be_instance_of(Jaeger::Client::Tracer) }
  end

  describe "::active_scope" do
    let(:scope_manager) { described_class.tracer.scope_manager }

    subject { described_class.active_scope }

    it "delegates the call to scope_manager of tracer" do
      expect(scope_manager).to receive(:active)

      subject
    end
  end

  describe "::active_span" do
    let(:tracer) { described_class.tracer }

    subject { described_class.active_span }

    it "delegates the call to tracer" do
      expect(tracer).to receive(:active_span)

      subject
    end
  end

  describe "::extract" do
    let(:extract_args) { [:foo, :bar] }
    let(:tracer) { described_class.tracer }

    subject { described_class.extract(*extract_args) }

    it "delegates the call to tracer" do
      expect(tracer).to receive(:extract).with(*extract_args)

      subject
    end
  end

  describe "::inject" do
    let(:inject_args) { [:foo, :bar] }
    let(:tracer) { described_class.tracer }

    subject { described_class.inject(*inject_args) }

    context "when there is no active span" do
      it "does not delegate the call to tracer" do
        expect(tracer).not_to receive(:inject)

        subject
      end
    end

    context "when there is an active span" do
      let(:mock_span) { double(:span, context: :foo) }
      let(:delegate_args) { [mock_span.context, *inject_args] }

      before do
        allow(described_class).to receive(:active_span).and_return(mock_span)
      end

      it "delegates the call to tracer" do
        expect(tracer).to receive(:inject).with(*delegate_args)

        subject
      end
    end
  end
end
