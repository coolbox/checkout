class ProductPromotion
  attr_accessor :id, :product_code, :minimum_quantity, :price

  def initialize(id, product_code, minimum_quantity, price)
    @id = id
    @product_code = product_code
    @minimum_quantity = minimum_quantity
    @price = price
  end

  def valid_for_this_basket?(code, actual_quantity)
    code == product_code && actual_quantity >= minimum_quantity
  end

  def amount_to_discount(products)
    quantity = products.length
    product_code = products.dig(0, "product_code")
    return 0.0 if !valid_for_this_basket?(product_code, quantity)
    original_total = products.map { |product| product["price"] }.sum
    return (original_total - (price.to_f * quantity))
  end
end
