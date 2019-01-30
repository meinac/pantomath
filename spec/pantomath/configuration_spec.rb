# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pantomath::Configuration do
  let(:configuration) { described_class.new }

  describe "#tag_collectors" do
    let(:tag_collector) { :foo }

    subject { configuration.tag_collectors.instrumenter }

    before { configuration.tag_collectors.instrumenter = tag_collector }

    it { is_expected.to eql(tag_collector) }
  end

  describe "#exclude_patterns" do
    let(:exclude_pattern) { :foo }

    subject { configuration.exclude_patterns.instrumenter }

    before { configuration.exclude_patterns.instrumenter = exclude_pattern }

    it { is_expected.to eql(exclude_pattern) }
  end
end
