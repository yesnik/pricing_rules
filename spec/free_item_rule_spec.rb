require 'spec_helper'
require './lib/free_item_rule.rb'

describe FreeItemRule do
  let(:voucher) { Product.new('Cabify Voucher', 'VOUCHER', 5.0) }
  let(:tshirt) { Product.new('Cabify T-Shirt', 'TSHIRT', 20.0) }
  let(:mug) { Product.new('Cafify Coffee Mug', 'MUG', 7.5) }

  test_cases = [
    {in: 1, out: 5.0},
    {in: 2, out: 5.0},
    {in: 3, out: 10.0},
    {in: 4, out: 10.0}
  ]

  describe '#price' do
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
end
