load "./product.rb"

class Checkout
  attr_accessor :items

  def initialize
    @items = []
  end

  # Append items to the sale
  def scan(product_id)
    product = Product.find(product_id)
    @items << product if product
  end

  # Total amount due
  def total
    sum = 0.00
    @items.each { |item| sum += item["price"] }
    return sum
  end
end
