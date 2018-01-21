class BasketPromotion
  attr_accessor :id, :minimum_spend, :discount

  def initialize(id, minimum_spend, discount)
    @id = id
    @minimum_spend = minimum_spend
    @discount = discount
  end
end
