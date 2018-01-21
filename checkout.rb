load "./product.rb"

class Checkout
  attr_accessor :items

  def initialize
    @items = []
  end

  # Append items to the sale
  def scan(product_id)
    @items << Product.new(product_id)
  end

  # Total amount due
  def total
    return 0.00 if @items.length == 0
    @items.each { |item| item[:price] }
  end
end
