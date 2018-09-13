class CheaperItemRule
  attr_reader :product, :applied_on_amount, :new_price

  def initialize(product, applied_on_amount, new_price)
    @product = product
    @applied_on_amount = applied_on_amount
    @new_price = new_price
  end

  def price(items)
    count = rule_items(items).size

    if count >= applied_on_amount
      new_price * count
    else
      product.price * count
    end
  end

  def rule_items(items)
    Array(items).select { |item| item.code.eql? product.code }
  end
end
