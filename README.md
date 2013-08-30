FlamingExpresso written in ![litCoffee Logo](https://raw.github.com/scanton/flaming-expresso/master/public/images/litCoffee-icon-horiz.png)
===============

A [litCoffee](http://litcoffee.org/) [Express](http://expressjs.com/) and [Socket.io](http://socket.io) based server
written in [Literate CoffeeScript](http://coffeescript.org/)
```coffeescript
  console.log 'FlamingExpresso - a litCoffee Express/Socket.io server'
```

#Compiling the client
Server-side files don't normally need to be compiled in this application.  But client-side files usually do.  You can compile the FlamingExpresso client and associated source-maps (used in Chrome for debugging CoffeeScript in the browser)

	sudo coffee -m -o "public/javascripts"  -c "client/app-client.coffee.md"

###How to run coffee under [node-inspector](https://github.com/node-inspector/node-inspector):

	coffee --nodejs --debug app.coffee.md

