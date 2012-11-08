# this. can be replaced with @

Products = new Meteor.Collection "Products"
Cart = new Meteor.Collection "Cart"

if Meteor.isClient
		Template.Products.ProductArr = ->
			Products.find {}, {sort: {name: 1}}

		Template.Products.events =
			"click .Product": ->
				if this.inStock
					if Cart.find({name: this.name, price: this.price}).count() > 0
						if confirm "Would you like to buy another #{this.name}?"
							Cart.update {name: this.name, price: this.price}, {$inc: {quantity: 1}}
					else
						if confirm "Would you like to buy a #{this.name} for $#{this.price}"
							Cart.insert {name: this.name, price: this.price, quantity: 1}
				else
					alert "That item is not in stock"

		Template.Cart.CartItems = ->
			Cart.find {}, {sort: {name: 1}}

		Template.Cart.Total = ->
			this.price * this.quantity

		Template.Cart.SubTotal = ->
			items = Cart.find {}
			total = 0

			items.forEach (item) ->
				total += item.price * item.quantity

			total
