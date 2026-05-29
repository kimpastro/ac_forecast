require "rails_helper"

RSpec.describe Zipcode do
  describe ".valid?" do
    subject(:valid_zipcode) { described_class.valid?(input) }

    context "when zipcode has 5 digits" do
      let(:input) { "12345" }

      it { is_expected.to be true }
    end

    context "when zipcode has ZIP+4 format" do
      let(:input) { "12345-6789" }

      it { is_expected.to be true }
    end

    context "when zipcode is invalid" do
      let(:input) { "1234" }

      it { is_expected.to be false }
    end

    context "when input is nil" do
      let(:input) { nil }

      it { is_expected.to be false }
    end

    context "when input contains formatting characters" do
      let(:input) { "12345 6789" }

      it { is_expected.to be true }
    end
  end

  describe ".normalize" do
    subject(:normalized_zipcode) { described_class.normalize(input) }

    context "when input is nil" do
      let(:input) { nil }

      it { is_expected.to be_nil }
    end

    context "when input has less then 5 digits" do
      let(:input) { "1234" }

      it { is_expected.to be_nil }
    end

    context "when input has 5 digits" do
      let(:input) { "12345" }

      it { is_expected.to eq(input) }
    end

    context "when input has more than 5 digits" do
      let(:input) { "1234567" }

      it { is_expected.to be_nil }
    end

    context "when zipcode has ZIP+4 format" do
      let(:input) { "12345-1234" }

      it { is_expected.to eq(input) }
    end

    context "when input contains extra non-digit characters" do
      let(:input) { "12345-1234unexpected" }

      it { is_expected.to eq("12345-1234") }
    end
  end
end
