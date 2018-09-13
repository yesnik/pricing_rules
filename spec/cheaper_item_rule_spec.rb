require 'spec_helper'
require './lib/cheaper_item_rule'
require './lib/product'

describe CheaperItemRule do
  let(:voucher) { Product.new('Cabify Voucher', 'VOUCHER', 5.0) }
  let(:tshirt) { Product.new('Cabify T-Shirt', 'TSHIRT', 20.0) }
  let(:mug) { Product.new('Cafify Coffee Mug', 'MUG', 7.5) }

  describe '#price' do
    test_cases = [
      {in: 1, out: 20.0},
      {in: 2, out: 40.0},
      {in: 3, out: 57.0},
      {in: 4, out: 76.0},
    ]

    test_cases.each do |test|
      subject { described_class.new(tshirt, 3, 19.0) }

      context "when min items amount is #{test[:in]}" do
        it do
          items = [tshirt] * test[:in]
          expect(subject.price(items)).to eq test[:out]
        end
      end
    end
  end
end
