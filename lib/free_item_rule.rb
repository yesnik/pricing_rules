class FreeItemRule
  attr_reader :product, :free_item_num

  def initialize(product, free_item_num)
    @product = product
    @free_item_num = free_item_num
  end

  def price(items)
    count = selected_items(items).size
    free_items_count = count / free_item_num
    (count - free_items_count) * product.price
  end

  protected

  def selected_items(items)
    items.select { |item| item.code = product.code }
  end
end
