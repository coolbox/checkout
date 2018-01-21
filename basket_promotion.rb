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
end
