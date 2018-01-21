require "./test/config.rb"
require "./basket_promotion.rb"

require "yaml"

BASKET_PROMOTIONS = YAML.load(File.read("config/basket_promotions.yml")
) unless defined?(BASKET_PROMOTIONS)

RSpec.describe BasketPromotion do
  describe "#initialize" do
    it "creates a basket promotion object with the relevant attributes" do
      promo = {id: 1, minimum_spend: 55.0, discount: 10}
      basket_promotion = BasketPromotion.new(
        promo[:id],
        promo[:minimum_spend],
        promo[:discount]
      )
      expect(basket_promotion).to have_attributes(
        id: promo[:id],
        minimum_spend: promo[:minimum_spend],
        discount: promo[:discount],
      )
    end
  end

  describe "valid_for_this_basket?" do
    let(:promo) { BasketPromotion.new(001, 50, 10) }

    it "returns false when the total isn't valid" do
      order_pre_discount_total = 10
      expect(promo.valid_for_this_basket?(order_pre_discount_total)).to(
        eq(false)
      )
    end

    it "returns true when the total is valid" do
      order_pre_discount_total = 100
      expect(promo.valid_for_this_basket?(order_pre_discount_total)).to(
        eq(true)
      )
    end
  end
end
