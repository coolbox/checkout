class ProductPromotion
  attr_accessor :id, :product_code, :minimum_quantity, :price

  def initialize(id, product_code, minimum_quantity, price)
    @id = id
    @product_code = product_code
    @minimum_quantity = minimum_quantity
    @price = price
  end
end
