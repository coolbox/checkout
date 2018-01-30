require "./checkout.rb"

RSpec.describe Checkout do
  subject { Checkout.new }

  describe "#scan" do
    it "adds a product to the basket" do
      subject.scan(001)
      expect(subject.items.length).to eq(1)
    end

    it "makes no change to the items array if no product is found" do
      subject.scan(001)
      subject.scan(10)
      expect(subject.items.length).to eq(1)
    end
  end

  describe "#running_total" do
    it "returns 0.0 when there are no items in the basket" do
      expect(subject.running_total).to eq(0.0)
    end

    it "returns a total when there are items in the basket" do
      product = {"product_code" => 001, "price" => 5.50}
      subject.instance_variable_set(:@items, [product, product])
      expected_price = product["price"] * 2
      expect(subject.running_total).to eq(expected_price)
    end
  end

  describe "#total" do
    it "returns 0.0 when there are no items in the basket" do
      expect(subject.total).to eq("£0.0")
    end

    context "with products" do
      let(:product) { {"product_code" => 001, "price" => 5.50} }

      context "without discounts" do
        it "returns a total of all products" do
          subject.instance_variable_set(:@items, [product, product])
          expect(subject.total).to be_kind_of(String)
        end
      end

      context "with discounts" do
        it "returns a total of all products, including discounts" do
          subject.instance_variable_set(:@items, [
            product, product, product, product
          ])
          expect(subject.total).to be_kind_of(String)
        end
      end
    end
  end

  describe "#basket_promotions" do
    context "with no promotions" do
      it "returns an empty array" do
        expect(subject.send(:basket_promotions)).to eq([])
      end
    end

    context "with some promotions" do
      let(:checkout) do
        Checkout.new(basket_promotion_rules: promo_rules)
      end

      let(:promo_rules) do
        promos = []
        (1..9).to_a.sample.times do |index|
          promos << {
            "id" => index + 1,
            "minimum_spend" => [20, 30, 40].sample,
            "discount" => [5, 10, 15].sample
          }
        end
        return promos
      end

      it "returns an array of basket promotions" do
        expect(checkout.send(:basket_promotions)).not_to be_empty
        expect(checkout.send(:basket_promotions)).to be_kind_of(Array)
      end

      it "returns basket promotions as BasketPromotion object instances" do
        expect(checkout.send(:basket_promotions).first).to be_instance_of(BasketPromotion)
      end
    end
  end

  describe "#basket_promotions" do
    context "with no promotions" do
      it "returns an empty array" do
        expect(subject.send(:basket_promotions)).to eq([])
      end
    end

    context "with some promotions" do
      let(:checkout) do
        Checkout.new(basket_promotion_rules: promo_rules)
      end

      let(:promo_rules) do
        promos = []
        (1..9).to_a.sample.times do |index|
          promos << {
            "id" => index + 1,
            "minimum_spend" => [20, 30, 40].sample,
            "discount" => [5, 10, 15].sample
          }
        end
        return promos
      end

      it "returns an array of basket promotions" do
        expect(checkout.send(:basket_promotions)).not_to be_empty
        expect(checkout.send(:basket_promotions)).to be_kind_of(Array)
      end

      it "returns basket promotions as BasketPromotion object instances" do
        expect(checkout.send(:basket_promotions).first).to be_instance_of(BasketPromotion)
      end
    end
  end

  describe "#with_basket_discounts" do
    let(:product) do
      return { "product_code" => 001, "price" => 5.50 }
    end

    before do
      allow(Product).to receive(:find).and_return(product)
    end

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
        expect(checkout.send(:with_basket_discounts)).to eq(product["price"])
      end
    end

    context "basket is above the minimum spend for a basket discount" do
      let(:checkout) do
        Checkout.new(basket_promotion_rules: [{
          "id" => 001,
          "minimum_spend" => (product["price"] / 2).round(2),
          "discount" => 10
        }])
      end

      it "returns the discounted basket total" do
        checkout.scan(product["product_code"])
        expected_price = (product["price"] * 0.9).round(2)
        expect(checkout.send(:with_basket_discounts)).to eq(expected_price)
      end
    end

    context "basket equals the minimum spend for a basket discount" do
      let(:checkout) do
        Checkout.new(basket_promotion_rules: [{
          "id" => 001,
          "minimum_spend" => product["price"],
          "discount" => 10
        }])
      end

      it "returns the discounted basket total" do
        checkout.scan(product["product_code"])
        expected_price = (product["price"] * 0.9).round(2)
        expect(checkout.send(:with_basket_discounts)).to eq(expected_price)
      end
    end
  end

  describe "#product_promotions" do
    context "with no promotions" do
      it "returns an empty array" do
        expect(subject.send(:product_promotions)).to eq([])
      end
    end

    context "with some promotions" do
      let(:checkout) do
        Checkout.new(product_promotion_rules: promo_rules)
      end

      let(:promo_rules) do
        promos = []
        (1..9).to_a.sample.times do |index|
          promos << {
            "id" => index + 1,
            "product_code" => (1..9).to_a.sample,
            "minimum_quantity" => (1..10).to_a.sample,
            "price" => 5
          }
        end
        return promos
      end

      it "returns an array of product promotions" do
        expect(checkout.send(:product_promotions)).not_to be_empty
        expect(checkout.send(:product_promotions)).to be_kind_of(Array)
      end

      it "returns product promotions as ProductPromotion object instances" do
        expect(checkout.send(:product_promotions).first).to(
          be_instance_of(ProductPromotion)
        )
      end
    end
  end

  describe "#with_product_discounts" do
    let(:product) { {"product_code" => 001, "price" => 5.50} }

    before do
      allow(Product).to receive(:find).and_return(product)
    end

    context "basket has no products valid for a discount" do
      it "returns the discounted basket total" do
        subject.scan(product["product_code"])
        expect(subject.send(:with_product_discounts)).to eq(product["price"])
      end
    end

    context "basket has products valid for a discount" do
      let(:checkout) do
        Checkout.new(product_promotion_rules: [{
          "id" => 001,
          "product_code" => 001,
          "minimum_quantity" => 2,
          "price" => 2
        }])
      end

      it "returns the discounted basket total" do
        checkout.scan(product["product_code"])
        checkout.scan(product["product_code"])
        checkout.scan(product["product_code"])
        expect(checkout.send(:with_product_discounts)).to eq(6)
      end
    end
  end
end
