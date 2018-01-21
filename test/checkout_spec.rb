require "./checkout.rb"
require "./basket_promotion.rb"

require "yaml"

PRODUCTS = YAML.load(File.read("config/products.yml")
) unless defined?(PRODUCTS)

BASKET_PROMOTION_RULES = YAML.load(File.read("config/basket_promotions.yml")
) unless defined?(BASKET_PROMOTION_RULES)

PRODUCT_PROMOTION_RULES = YAML.load(File.read("config/basket_promotions.yml")
) unless defined?(PRODUCT_PROMOTION_RULES)

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

  describe "#running_total" do
    let(:checkout) { Checkout.new }

    it "returns 0.0 when there are no items in the basket" do
      expect(checkout.running_total).to eq(0.0)
    end

    it "returns a total when there are items in the basket" do
      product = PRODUCTS[0]

      2.times do
        checkout.scan(product["product_code"])
      end

      expected_price = product["price"] * 2
      expect(checkout.running_total).to eq(expected_price)
    end
  end

  describe "#total" do
    let(:checkout) { Checkout.new }

    it "returns 0.0 when there are no items in the basket" do
      expect(checkout.total).to eq("£0.0")
    end

    context "with products" do
      let(:product) { PRODUCTS[0] }

      context "without discounts" do
        it "returns a total of all products" do
          2.times do
            checkout.scan(product["product_code"])
          end
          expect(checkout.total).to be_kind_of(String)
        end
      end

      context "with discounts" do
        it "returns a total of all products, including discounts" do
          10.times do
            checkout.scan(product["product_code"])
          end
          expect(checkout.total).to be_kind_of(String)
        end
      end
    end
  end

  describe "#basket_promotions" do
    context "with no promotions" do
      let(:checkout) { Checkout.new }

      it "returns an empty array" do
        expect(checkout.basket_promotions).to eq([])
      end
    end

    context "with some promotions" do
      let(:checkout) do
        Checkout.new(basket_promotion_rules: BASKET_PROMOTION_RULES)
      end

      let(:promos) {
        promos = []
        BASKET_PROMOTION_RULES.each do |bp|
          promos << BasketPromotion.new(
            bp[:id],
            bp[:minimum_spend],
            bp[:discount]
          )
        end
        return promos
      }

      it "returns an array of basket promotions" do
        expect(checkout.basket_promotions).not_to be_empty
        expect(checkout.basket_promotions).to be_kind_of(Array)
      end

      it "returns basket promotions as BasketPromotion object instances" do
        expect(checkout.basket_promotions.first).to be_instance_of(BasketPromotion)
      end
    end
  end

  describe "#basket_promotions" do
    context "with no promotions" do
      let(:checkout) { Checkout.new }

      it "returns an empty array" do
        expect(checkout.basket_promotions).to eq([])
      end
    end

    context "with some promotions" do
      let(:checkout) do
        Checkout.new(basket_promotion_rules: BASKET_PROMOTION_RULES)
      end

      let(:promos) {
        promos = []
        BASKET_PROMOTION_RULES.each do |promo_rule|
          promos << BasketPromotion.new(
            promo_rule[:id],
            promo_rule[:minimum_spend],
            promo_rule[:discount]
          )
        end
        return promos
      }

      it "returns an array of basket promotions" do
        expect(checkout.basket_promotions).not_to be_empty
        expect(checkout.basket_promotions).to be_kind_of(Array)
      end

      it "returns basket promotions as BasketPromotion object instances" do
        expect(checkout.basket_promotions.first).to be_instance_of(BasketPromotion)
      end
    end
  end

  describe "#with_basket_discounts" do
    let(:product) { PRODUCTS[0] }

    context "basket is below the minimum spend for a basket discount" do
      let(:checkout) do
        Checkout.new(basket_promotion_rules: [{
          "id": 001,
          "minimum_spend": product["price"] * 1000.0,
          "discount": 10
        }])
      end

      it "returns the discounted basket total" do
        checkout.scan(product["product_code"])
        expect(checkout.with_basket_discounts).to eq(product["price"])
      end
    end

    context "basket is above the minimum spend for a basket discount" do
      let(:checkout) do
        Checkout.new(basket_promotion_rules: [{
          "id": 001,
          "minimum_spend": (product["price"] / 2).round(2),
          "discount": 10
        }])
      end

      it "returns the discounted basket total" do
        checkout.scan(product["product_code"])
        expected_price = (product["price"] * 0.9).round(2)
        expect(checkout.with_basket_discounts).to eq(expected_price)
      end
    end

    context "basket equals the minimum spend for a basket discount" do
      let(:checkout) do
        Checkout.new(basket_promotion_rules: [{
          "id": 001,
          "minimum_spend": product["price"],
          "discount": 10
        }])
      end

      it "returns the discounted basket total" do
        checkout.scan(product["product_code"])
        expected_price = (product["price"] * 0.9).round(2)
        expect(checkout.with_basket_discounts).to eq(expected_price)
      end
    end
  end

  describe "#product_promotions" do
    context "with no promotions" do
      let(:checkout) { Checkout.new }

      it "returns an empty array" do
        expect(checkout.product_promotions).to eq([])
      end
    end

    context "with some promotions" do
      let(:checkout) do
        Checkout.new(product_promotion_rules: PRODUCT_PROMOTION_RULES)
      end

      let(:promos) {
        promos = []
        PRODUCT_PROMOTION_RULES.each do |promo_rule|
          promos << ProductPromotion.new(
            promo_rule[:id],
            promo_rule[:product_code],
            promo_rule[:minimum_quantity],
            promo_rule[:price]
          )
        end
        return promos
      }

      it "returns an array of product promotions" do
        expect(checkout.product_promotions).not_to be_empty
        expect(checkout.product_promotions).to be_kind_of(Array)
      end

      it "returns product promotions as ProductPromotion object instances" do
        expect(checkout.product_promotions.first).to(
          be_instance_of(ProductPromotion)
        )
      end
    end
  end

  describe "#with_product_discounts" do
    let(:product) do
      product = PRODUCTS[0]
    end

    context "basket has no products valid for a discount" do
      let(:checkout) do
        Checkout.new
      end

      it "returns the discounted basket total" do
        checkout.scan(product["product_code"])
        expect(checkout.with_product_discounts).to eq(product["price"])
      end
    end

    context "basket has products valid for a discount" do
      let(:checkout) do
        Checkout.new(product_promotion_rules: [{
          "id": 001,
          "product_code": 001,
          "minimum_quantity": 2,
          "price": 2
        }])
      end

      it "returns the discounted basket total" do
        checkout.scan(product["product_code"])
        checkout.scan(product["product_code"])
        checkout.scan(product["product_code"])
        expect(checkout.with_product_discounts).to eq(6)
      end
    end
  end
end
