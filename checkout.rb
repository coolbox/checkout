load "./product.rb"
load "./basket_promotion.rb"
load "./product_promotion.rb"

BASKET_PROMOTION_RULES = YAML.load(File.read("config/basket_promotions.yml")
) unless defined?(BASKET_PROMOTION_RULES)

PRODUCT_PROMOTION_RULES = YAML.load(File.read("config/product_promotions.yml")
) unless defined?(PRODUCT_PROMOTION_RULES)

class Checkout
  attr_accessor :items, :basket_promotion_rules, :product_promotion_rules

  def initialize(basket_promotion_rules: [], product_promotion_rules: [])
    @items = []
    @basket_promotion_rules = basket_promotion_rules
    @product_promotion_rules = product_promotion_rules
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

  # Total to charge customer,
  # with discounts applied
  def total
    total = with_product_discounts
    total = with_basket_discounts(total)
    return "£#{total}"
  end

  private

  def basket_promotions
    promos = []
    basket_promotion_rules.each do |promo_rule|
      promos << BasketPromotion.new(
        promo_rule["id"],
        promo_rule["minimum_spend"],
        promo_rule["discount"]
      )
    end
    return promos
  end

  def product_promotions
    promos = []
    product_promotion_rules.each do |promo_rule|
      promos << ProductPromotion.new(
        promo_rule["id"],
        promo_rule["product_code"],
        promo_rule["minimum_quantity"],
        promo_rule["price"]
      )
    end
    return promos
  end

  def with_basket_discounts(total_to_apply_discounts_to = running_total)
    discounted_total = total_to_apply_discounts_to
    basket_promotions.each do |promo|
      next if !promo.valid_for_this_basket?(total_to_apply_discounts_to)
      discounted_total = promo.discounted_price(discounted_total)
    end
    return discounted_total.round(2)
  end

  def with_product_discounts
    amount_to_discount = 0
    product_groups = @items.group_by { |item| item["product_code"] }
    product_groups.each do |group, items|
      product_promotions.each do |promo|
        amount_to_discount += promo.amount_to_discount(items)
      end
    end
    return running_total - amount_to_discount
  end
end
