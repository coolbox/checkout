require "yaml"

class ProductPromotion
  PRODUCT_PROMOTIONS = YAML.load(File.read("config/product_promotions.yml")
  ) unless defined?(PRODUCT_PROMOTIONS)

  attr_accessor :id, :product_code, :minimum_quantity, :price
end
