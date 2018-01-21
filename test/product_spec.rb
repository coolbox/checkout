require "./test/config.rb"
require "./product.rb"

require "yaml"

PRODUCTS = YAML.load(File.read("config/products.yml")
) unless defined?(PRODUCTS)

RSpec.describe Product do
  describe "#find" do
    it "finds a product with the supplied code" do
      product = PRODUCTS[0]
      expect(Product.find(001)).to eq(product)
    end

    it "returns nil if there is no product" do
      expect(Product.find(10)).to be_nil
    end
  end
end
