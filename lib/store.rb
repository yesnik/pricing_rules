class Store
  @@product_per_code = {}

  class << self
    def add_product(product)
      @@product_per_code[product.code] = product
    end

    def product_for_code(code)
      @@product_per_code[code]
    end
  end
end
