class Checkout
  attr_accessor :items, :pricing_rules

  def initialize(pricing_rules)
    @items = []
    @pricing_rules = pricing_rules
  end

  def scan(code)
    @items << Store.product_for_code(code)
  end

  def total_price
    items_to_process = items.dup
    sum = 0

    pricing_rules.each do |rule|
      items_for_rule = rule.rule_items(items_to_process)
      sum += rule.price(items_for_rule)
      items_to_process -= items_for_rule
    end

    sum += items_to_process.sum(&:price)
    sum
  end
end
