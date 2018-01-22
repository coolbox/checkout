class BasketPromotion
  attr_accessor :id, :minimum_spend, :discount

  def initialize(id, minimum_spend, discount)
    @id = id
    @minimum_spend = minimum_spend
    @discount = discount
  end

  def valid_for_this_basket?(basket_pre_discont_total)
    basket_pre_discont_total.to_f >= minimum_spend.to_f
  end

  def discounted_price(original_price = 0.0)
    # 10% discount on 100
    # 100 - (100 * (10 / 100))
    decimal_discount = (discount.to_f / 100.0)
    price_after_discount = original_price * decimal_discount
    return original_price - price_after_discount
  end
end
