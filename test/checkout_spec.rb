require "./test/config.rb"
require "./checkout.rb"

require "yaml"

PRODUCTS = YAML.load(File.read("config/products.yml")
) unless defined?(PRODUCTS)

RSpec.describe Checkout do
  describe "#scan" do
    it "adds a product to the basket" do
      checkout = Checkout.new
      checkout.scan(001)
      expect(checkout.items.length).to eq(1)
    end
  end

  describe "#total" do
    it "returns 0.0 when there are no items in the basket" do
      checkout = Checkout.new
      expect(checkout.total).to eq(0.0)
    end

    it "returns a total when there are items in the basket" do
      product = build(:product,
        product_code: 001,
        name: "Product 1",
        price: 5
      )
    end
  end

  # context "with a 10% basket discount" do
  #   describe "#total" do
  #     it "returns a discounted basket total" do
  #     end
  #   end
  # end
end
