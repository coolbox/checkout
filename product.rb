require "yaml"

class Product
  PRODUCTS = YAML.load(File.read("config/products.yml")
  ) unless defined?(PRODUCTS)

  def self.find(product_code)
    PRODUCTS.find do |product|
      product["product_code"] == product_code
    end
  end
end
