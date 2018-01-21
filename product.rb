require "yaml"

class Product
  PRODUCTS = YAML.load(File.read("config/products.yml")
  ) unless defined?(PRODUCTS)

  attr_accessor :product_code, :attributes

  def initialize(product_code)
    @product_code = product_code
    @attributes = find_product
  end

  def find_product
    PRODUCTS.find do |product|
      product["product_code"] == @product_code
    end
  end
end
