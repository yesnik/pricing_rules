require 'spec_helper'
require './lib/free_item_rule'
require './lib/product'

describe FreeItemRule do
  let(:voucher) { Product.new('Cabify Voucher', 'VOUCHER', 5.0) }
  let(:tshirt) { Product.new('Cabify T-Shirt', 'TSHIRT', 20.0) }
  let(:mug) { Product.new('Cafify Coffee Mug', 'MUG', 7.5) }

  describe '#price' do
    test_cases = [
      {in: 1, out: 5.0},
      {in: 2, out: 5.0},
      {in: 3, out: 10.0},
      {in: 4, out: 10.0}
    ]

    test_cases.each do |test|
      subject { FreeItemRule.new(voucher, 2) }

      context "when target amount is #{test[:in]}" do
        it do
          items = [voucher] * test[:in]
          expect(subject.price(items)).to eq test[:out]
        end
      end
    end
  end

  describe '#rule_items' do
    subject { FreeItemRule.new(voucher, 2) }

    context 'when items is nil' do
      it 'returns empty array' do
        expect(subject.rule_items(nil)).to eq []
      end
    end

    context 'when items is not empty' do
      let(:items) { [voucher, tshirt, voucher] }

      it 'returns items of type defined in rule' do
        expect(subject.rule_items(items)).to eq [voucher, voucher]
      end
    end
  end
end
