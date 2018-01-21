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

  describe "valid_for_this_basket?" do
    let(:promo) { ProductPromotion.new(001, 001, 2, 2) }

    context "with a valid product code" do
      it "returns false when the total isn't valid" do
        expect(promo.valid_for_this_basket?(001, 1)).to eq(false)
      end

      it "returns true when the quantity is equal to the minimum" do
        expect(promo.valid_for_this_basket?(001, 2)).to eq(true)
      end

      it "returns true when the quantity is greate than the minimum" do
        expect(promo.valid_for_this_basket?(001, 3)).to eq(true)
      end
    end

    context "with an invalid product code" do
      it "returns false when the total isn't valid" do
        expect(promo.valid_for_this_basket?(002, 1)).to eq(false)
      end

      it "returns true when the quantity is equal to the minimum" do
        expect(promo.valid_for_this_basket?(002, 2)).to eq(false)
      end

      it "returns true when the quantity is greate than the minimum" do
        expect(promo.valid_for_this_basket?(002, 3)).to eq(false)
      end
    end
  end
end
