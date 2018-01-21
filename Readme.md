# Vinterior Coding Test

Solution by Peter Roome

Email: [pete.roome@gmail.com](mailto: pete.roome@gmail.com)

## Get started
1. Open a terminal window
2. Clone the repository
```
git clone git@github.com:coolbox/vinterior.git
```

2. `cd` into the repository folder
```
cd vinterior
```

3. Install the `bundler` gem
```
gem install bundler
```

4. Install the required gems
```
bundle Install
```

## How to run the tests
1. In a terminal window, within the `vinterior` repository, run `rspec`
```
rspec ./test/*
```

## How to run the checkout
1. In a terminal window, within the `vinterior` repository, run `irb`
```
irb
```

2. Either type, line by line, or copy and paste each of the test scenarios below, into `irb` e.g:

```
load "./checkout.rb"
c = Checkout.new(basket_promotion_rules: BASKET_PROMOTION_RULES, product_promotion_rules: PRODUCT_PROMOTION_RULES)
c.scan(001)
c.scan(002)
c.scan(003)
c.total
```

## Test Scenarios
### Scenario 1
```
load "./checkout.rb"
c = Checkout.new(basket_promotion_rules: BASKET_PROMOTION_RULES, product_promotion_rules: PRODUCT_PROMOTION_RULES)
c.scan(001)
c.scan(002)
c.scan(003)
c.total
```
Expected result: `£66.78`

### Scenario 2
```
load "./checkout.rb"
c = Checkout.new(basket_promotion_rules: BASKET_PROMOTION_RULES, product_promotion_rules: PRODUCT_PROMOTION_RULES)
c.scan(001)
c.scan(003)
c.scan(001)
c.total
```

Expected result: `£36.95`

### Scenario 3
```
load "./checkout.rb"
c = Checkout.new(basket_promotion_rules: BASKET_PROMOTION_RULES, product_promotion_rules: PRODUCT_PROMOTION_RULES)
c.scan(001)
c.scan(002)
c.scan(001)
c.scan(003)
c.total
```

Expected result: `£73.76`

## Next steps
Although the code satisfies the brief, there are a few weaknesses with this implementation. With more time, I would:

- The solution only outputs an floating point number, rather than a currency.

- Limit the number of discounts that could be applied to products and the basket as a whole. As it stands the Marketing team could add multiple basket promotions and all of them would be applied to the basket, if they satisfied the promotion's conditions. From the business' point of view, the customer should only receive one basket promotion. This is the same for product promotions too.

- There is a lot of logic in the `with_basket_discounts` and `with_product_discounts` methods in the `Checkout` class. I would like to abstract some of the logic here into the `BasketPromotion` and `ProductPromotion` classes. This would simplify the `Checkout` class and make these methods more readable.

- The `Product` class implementation could be better. Currently it just finds an object from the products loaded from the YAML file. I think this class should instead receive arguments, such as `code`, `name` and `price`, in order to build a `Product`. That way methods could be created on the `Product` class, if needed. I didn't find this necessary for this brief though.

- `ProductPromotion` and `BasketPromotion` both require defined arguments to be passed through to create an instance of each. As the solution expands, a more versatile approach would be to pass through an object of `args` and define this on each class like this, for example:

```
def initialize(args = {})
  @id = params.fetch(:id, nil)
  @product_code = params.fetch(:product_code, 001)
  @minimum_quantity = params.fetch(:minimum_quantity, 2)
  @price = params.fetch(:price, 0.00)  
end
```
or
```
def initialize(*args)
  @id, @product_code, @minimum_quantity, @price = args
end
```