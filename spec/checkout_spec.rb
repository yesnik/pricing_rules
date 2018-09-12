require 'spec_helper'
require './lib/checkout'
require './lib/product'
require './lib/store'

describe Checkout do
  let(:voucher) { Product.new('Cabify Voucher', 'VOUCHER', 5.0) }
  let(:tshirt) { Product.new('Cabify T-Shirt', 'TSHIRT', 20.0) }
  let(:mug) { Product.new('Cafify Coffee Mug', 'MUG', 7.5) }

  before do
    Store.add_product(voucher)
    Store.add_product(tshirt)
    Store.add_product(mug)
  end
  

  let(:pricing_rules) { [] }

  subject { described_class.new(pricing_rules) }

  describe '#scan' do
    context 'when we scan one product' do
      before { subject.scan('VOUCHER') }

      it 'adds product to items' do
        expect(subject.items).to eq [voucher]
      end
    end

    context 'when we scan one product 2 times' do
      before { 2.times { subject.scan('TSHIRT') } }

      it 'adds product to items' do
        expect(subject.items).to eq [tshirt, tshirt]
      end
    end

    context 'when we scan 3 different products' do
      before do
        subject.scan 'VOUCHER'
        subject.scan 'TSHIRT'
        subject.scan 'MUG'
      end

      it 'adds these 3 products to items' do
        expect(subject.items).to eq [voucher, tshirt, mug]
      end
    end
  end

  describe '#total' do
    context 'when no pricing rules' do
      context 'when only one product' do
        before do
          allow(subject).to receive(:items).and_return([voucher])
        end

        it 'returns price of product' do
          expect(subject.total).to eq voucher.price
        end
      end

      context 'when several products were scanned' do
        before do
          allow(subject).to receive(:items).and_return([voucher, tshirt, mug])
        end

        it 'returns sum of this products prices' do
          expect(subject.total).to eq 32.5
        end
      end
    end
  end
end
