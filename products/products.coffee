# @ is same as this.

Products = new Meteor.Collection "Products"
Cart = new Meteor.Collection "Cart"

if Meteor.isClient
  Template.Products.ProductArr = ->
    Products.find {}, {sort: {name: 1}}

  Template.Products.events =
    "click .Product": ->
      if @inStock
        if Cart.find({name: @name, price: @price}).count() > 0
          if confirm "Would you like to buy another #{@name}?"
            Cart.update {name: @name, price: @price}, {$inc: {quantity: 1}}
        else
          if confirm "Would you like to buy a #{@name} for $#{@price}"
            Cart.insert {name: @name, price: @price, quantity: 1}
      else
        alert "That item is not in stock"

  Template.Cart.CartItems = ->
    Cart.find {}, {sort: {name: 1}}

  Template.Cart.Total = ->
    @price * @quantity

  Template.Cart.SubTotal = ->
    items = Cart.find {}
    total = 0

    items.forEach (item) ->
      total += item.price * item.quantity

    total
