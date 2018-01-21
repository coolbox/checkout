require "./test/config.rb"
require "./product_promotion.rb"

require "yaml"

RSpec.describe ProductPromotion do
  describe "#initialize" do
    it "creates a basket promotion object with the relevant attributes" do
      promo = {
        id: 1,
        product_code: 001,
        minimum_quantity: 2,
        price: 8.5
      }

      basket_promotion = ProductPromotion.new(
        promo[:id],
        promo[:product_code],
        promo[:minimum_quantity],
        promo[:price],
      )

      expect(basket_promotion).to have_attributes(
        id: promo[:id],
        product_code: promo[:product_code],
        minimum_quantity: promo[:minimum_quantity],
        price: promo[:price],
      )
    end
  end
end
