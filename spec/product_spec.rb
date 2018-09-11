require 'spec_helper'
require './lib/product'

describe Product do
  describe '#initialize' do
    let(:name) { 'Cabify Voucher' }
    let(:code) { 'VOUCHER' }
    let(:price) { 5.0 }

    subject { described_class.new(name, code, price) }

    it 'sets name' do
      expect(subject.name).to eq name
    end

    it 'sets code' do
      expect(subject.code).to eq code
    end

    it 'sets price' do
      expect(subject.price).to eq price
    end
  end
end
