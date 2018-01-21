require "yaml"

class BasketPromotion
  BASKET_PROMOTIONS = YAML.load(File.read("config/basket_promotions.yml")
  ) unless defined?(BASKET_PROMOTIONS)

  attr_accessor :id, :minimum_spend, :discount
end
