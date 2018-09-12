class Checkout
  attr_accessor :items, :pricing_rules

  def initialize(pricing_rules)
    @items = []
    @pricing_rules = pricing_rules
  end

  def scan(code)
    @items << Store.product_for_code(code)
  end

  def total
    items.sum(&:price)
  end
end
