module PricingRule
  class FreeItem
    attr_reader :product, :free_item_num

    def initialize(product, free_item_num)
      @product = product
      @free_item_num = free_item_num
    end

    def price(items)
      count = rule_items(items).size
      free_items_count = count / free_item_num
      (count - free_items_count) * product.price
    end

    def rule_items(items)
      Array(items).select { |item| item.code.eql? product.code }
    end
  end
end
