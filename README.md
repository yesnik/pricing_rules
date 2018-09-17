# Cabify Ruby Challenge

Besides providing exceptional transportation services, Cabify also runs 
a physical store which sells (only) 3 products:

``` 
Code         | Name                |  Price
-------------------------------------------------
VOUCHER      | Cabify Voucher      |   5.00€
TSHIRT       | Cabify T-Shirt      |  20.00€
MUG          | Cafify Coffee Mug   |   7.50€
```

Various departments have insisted on the following discounts:

 * The marketing department believes in 2-for-1 promotions (buy two of the same product, get one free), and would like for there to be a 2-for-1 special on `VOUCHER` items.

 * The CFO insists that the best way to increase sales is with discounts on bulk purchases (buying x or more of a product, the price of that product is reduced), and demands that if you buy 3 or more `TSHIRT` items, the price per unit should be 19.00€.

Cabify's checkout process allows for items to be scanned in any order, and should return the total amount to be paid. The interface for the checkout process looks like this (ruby):

```ruby
co = Checkout.new(pricing_rules)
co.scan("VOUCHER")
co.scan("VOUCHER")
co.scan("TSHIRT")
price = co.total
```

Using ruby (>= 2.0), implement a checkout process that fulfills the requirements.

Examples:

```
Items: VOUCHER, TSHIRT, MUG
Total: 32.50€

Items: VOUCHER, TSHIRT, VOUCHER
Total: 25.00€

Items: TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT
Total: 81.00€

Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT
Total: 74.50€
```

**The code should:**
- Be written as production-ready code. You will write production code.
- Be easy to grow and easy to add new functionality.
- Have notes attached, explaining the solution and why certain things are included and others are left out.

## Solution

### Tests

To see this code in action run tests:

```
cd pricing_rules
rspec
```

### Description

In the task we can see example of desired checkout process:

```ruby
co = Checkout.new(pricing_rules)
co.scan("VOUCHER")
co.scan("VOUCHER")
co.scan("TSHIRT")
price = co.total
```

That's why we created `lib/checkout.rb` file. 

This `Checkout` class takes `pricing_rules` as argument. Therefore we created `lib/pricing_rule` folder and placed there 2 pricing strategies:

- `pricing_rule/cheaper_item.rb` - this class contains logic: buying x or more of a product, the price of that product is reduced;
- `pricing_rule/free_item.rb` - this class contains logic: buy two of the same product, get one free.

If we want to add another pricing rule we'll just create new class there.

Also we can see that `Checkout` class should have `scan` method that takes product's code. 

To calculate total order's price we need somehow to define price for each order's product and then apply pricing rules.

We created `Product` class to store info about each product: `code`, `price`, `name`.

Method `Checkout#scan` have to get product by product's code, that's why we created `Store` class to hold all products there.

Method `Checkout#total` calls `Checkout#total_price` and formats the output like this: `32.50€`. 
