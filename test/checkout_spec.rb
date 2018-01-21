require "./test/config.rb"
require "./checkout.rb"

require "yaml"

PRODUCTS = YAML.load(File.read("config/products.yml")
) unless defined?(PRODUCTS)

BASKET_PROMOTIONS = YAML.load(File.read("config/basket_promotions.yml")
) unless defined?(BASKET_PROMOTIONS)

RSpec.describe Checkout do
  describe "#scan" do
    let(:checkout) { Checkout.new }

    it "adds a product to the basket" do
      checkout.scan(001)
      expect(checkout.items.length).to eq(1)
    end

    it "makes no change to the items array if no product is found" do
      checkout.scan(001)
      checkout.scan(10)
      expect(checkout.items.length).to eq(1)
    end
  end

  describe "#total" do
    let(:checkout) { Checkout.new }

    it "returns 0.0 when there are no items in the basket" do
      expect(checkout.total).to eq(0.0)
    end

    it "returns a total when there are items in the basket" do
      product = PRODUCTS[0]

      2.times do
        checkout.scan(product["product_code"])
      end

      expected_price = product["price"] * 2
      expect(checkout.total).to eq(expected_price)
    end
  end

  # context "with a 10% basket discount" do
  #   describe "#total" do
  #     it "returns a discounted basket total" do
  #     end
  #   end
  # end
end
