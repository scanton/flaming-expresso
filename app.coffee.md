#app.coffee.md ![litCoffee Logo](https://raw.github.com/scanton/flaming-expresso/master/public/images/litCoffee-icon.png)

##main (bootstrap) **SERVER**
This is the *main* application bootstrapping file that sets
up the web server and defines routes.

####Include external packages

external package requirements are defined in package.json
in this same root directory

##HTTP
Http provides http protocol api

	http = require 'http'

##Express (web server)
[Express](http://expressjs.com/) is our web server

	express = require 'express'

##File System
We're going to need file system access to write server logs

	fs = require 'fs'

##Path
This library helps us work with file system paths

	path = require 'path'

#app
**app** is our reference to the webserver

	app = express()

##Config
This will allow us to store basic configuration details, like
database connections, or WSDLs based on the specific environment
(e.g. 'development', 'production', 'staging', etc.)

	config = require('./config.json')[app.get('env')]

##Port(set)
If no environment variable *PORT* is defined, then we listen
to port 3000 by default.

	app.set 'port', process.env.PORT || 3000

##Views
The app will look for views in a folder called */views*

	app.set 'views', __dirname + '/views'

##Jade
Register Jade as the view engine. 

[Jade](http://jade-lang.com/) is the HTML templating engine used in
this application.

	app.set 'view engine', 'jade'

##Web Basics
Instruct the app to use some basic webserver functionality

	app.use express.favicon()
	app.use express.responseTime()
	app.use express.bodyParser()
	app.use express.methodOverride()

##Logging
We use Express' logger to write server logs to a file 'app.log' in
the root directory of this application.

	app.use express.logger
		format: ':date :remote-addr :method :url :status'
		stream: fs.createWriteStream 'app.log', 'flags': 'w'

##cookies
	app.use express.cookieParser 'cookie secret here'

##session
	app.use express.session()

##Router
We want to use the app.router middleware before using
express.errorHandler middleware below.

	app.use app.router

##Stylus
Register Stylus as the style middleware

[Stylus](http://learnboost.github.io/stylus/) is the CSS style language
used in this application.

	app.use require('stylus').middleware __dirname + '/public'

##Static 'public' directory
We're going to expose files that need to be served to the browser
(e.g. images, styleseets and javascripts) in a public folder

This prevents our application code (server-side litCoffee) from being
viewable from the web.

	app.use express.static path.join __dirname, 'public'

##Error Handling
If we are in the development environment, then we enable error handling

	if 'development' == app.get('env')
		app.use express.errorHandler()

##Route all requests to 'index'
This is where we declare routes for our router to use.  In our case,
we're going to handle application routing seperately from the main router.
So we set this rule to respond to all GET HTTP requests by rendring the
index:
	
	app.get '/', (req, res) ->
		res.render 'index',
			title: config.title
			tagline: config.tagline

##Port(get)
Get the port number the application will be listening to (this was set in
[Port(set)](#portset) above)

	port = app.get 'port'

#CreateServer
Construct the http server by passing a reference to the app then
register for listen events on that port.

	server = http.createServer(app).listen port, ->
		console.log "Express server listening on port #{port}"

#Web Sockets (socket.io)
We're going to use socket.io as our socket server.  We pass a
reference to our existing 'server', meaning socket.io will be able
to respond to socket oriented HTTP requests on the same port as the
web server.

	io = require('socket.io').listen server

###Socket events
We then register to listen for the *connection* event and define our
event handlers for an individual socket

	io.sockets.on 'connection', (socket) ->
		soc = socket
		d = new Date();
		soc.emit 'onConnect', 
			message: "Connected to #{config.title}"
			date: d.toString()
			time: d.getTime()
		soc.on 'onConnect', (data) ->
			console.log data
		soc.on 'onChat', (data) ->
			data.username = soc.username
			io.sockets.emit 'updateChat', data
		soc.on 'setName', (data) ->
			socket.username = data.message
			io.sockets.emit 'newUser', data
