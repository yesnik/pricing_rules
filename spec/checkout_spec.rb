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
  
  describe '#scan' do
    let(:pricing_rules) { [] }
    subject { described_class.new(pricing_rules) }

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
    let(:pricing_rules) { [] }
    subject { described_class.new(pricing_rules) }

    test_cases = [
      {in: 10.0, out: '10.00€'},
      {in: 0.55, out: '0.55€'},
      {in: 100, out: '100.00€'}
    ]

    test_cases.each do |test|
      it "formats price to #{test[:out]}" do
        allow(subject).to receive(:total_price).and_return(test[:in])

        expect(subject.total).to eq test[:out]
      end
    end
  end

  describe '#total_price' do
    context 'when no pricing rules' do
      let(:pricing_rules) { [] }
      subject { described_class.new(pricing_rules) }

      context 'when only one product' do
        before do
          allow(subject).to receive(:items).and_return([voucher])
        end

        it 'returns price of product' do
          expect(subject.send :total_price).to eq voucher.price
        end
      end

      context 'when several products were scanned' do
        before do
          allow(subject).to receive(:items).and_return([voucher, tshirt, mug])
        end

        it 'returns sum of this products prices' do
          expect(subject.send :total_price).to eq 32.5
        end
      end
    end

    context 'when FreeItemRule provided' do
      let(:pricing_rules) { [FreeItemRule.new(voucher, 2)] }
      subject { described_class.new(pricing_rules) }

      context 'when we have items for single pricing rule' do
        before do
          allow(subject).to receive(:items).and_return([voucher, tshirt, voucher])
        end

        it 'returns price with discount applied' do
          expect(subject.send :total_price).to eq 25.0
        end
      end
    end

    context 'when CheaperItemRule provided' do
      let(:pricing_rules) { [CheaperItemRule.new(tshirt, 3, 19.0)] }
      subject { described_class.new(pricing_rules) }

      context 'when we have items for single pricing rule' do
        before do
          allow(subject).to receive(:items).
            and_return([tshirt, tshirt, tshirt, voucher, tshirt])
        end

        it 'returns price with discount applied' do
          expect(subject.send :total_price).to eq 81.0
        end
      end
    end

    context 'when FreeItemRule and CheaperItemRule applied' do
      let(:pricing_rules) do
        [CheaperItemRule.new(tshirt, 3, 19.0), FreeItemRule.new(voucher, 2)]
      end

      subject { described_class.new(pricing_rules) }

      context 'when we have items for 2 pricing rules' do
        before do
          allow(subject).to receive(:items).
            and_return([voucher, tshirt, voucher, voucher, mug, tshirt, tshirt])
        end

        it 'returns price with discount applied' do
          expect(subject.send :total_price).to eq 74.5
        end
      end

      context 'when we do not have any items for pricing rules' do
        before do
          allow(subject).to receive(:items).and_return([voucher, tshirt, mug])
        end

        it 'returns price with discount applied' do
          expect(subject.send :total_price).to eq 32.5
        end
      end
    end
  end
end
