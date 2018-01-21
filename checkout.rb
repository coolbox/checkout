load "./product.rb"
load "./basket_promotion.rb"

BASKET_PROMOTION_RULES = YAML.load(File.read("config/basket_promotions.yml")
) unless defined?(BASKET_PROMOTION_RULES)

class Checkout
  attr_accessor :items, :basket_promotion_rules

  def initialize(basket_promotion_rules: [])
    @items = []
    @basket_promotion_rules = basket_promotion_rules
  end

  # Append items to the sale
  def scan(product_id)
    product = Product.find(product_id)
    @items << product if product
  end

  # Running total amount due
  # No discounts applied
  def running_total
    sum = 0.00
    @items.each { |item| sum += item["price"] }
    return sum
  end

  def basket_promotions
    promos = []
    basket_promotion_rules.each do |bp|
      promos << BasketPromotion.new(
        bp[:id],
        bp[:minimum_spend],
        bp[:discount]
      )
    end
    return promos
  end

  def with_basket_discounts
    discounted_total = running_total
    basket_promotions.each do |promo|
      next if !promo.valid_for_this_basket?(running_total)
      # 10% discount on 100
      # 100 - (100 * (10 / 100))
      discount = (promo.discount.to_f / 100.0)
      total_after_discount = discounted_total * discount
      discounted_total = discounted_total - total_after_discount
    end
    return discounted_total.round(2)
  end
end
