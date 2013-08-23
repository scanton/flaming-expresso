#app.coffee.md
An [express](http://expressjs.com/) based 
[Literate CoffeeScript](http://coffeescript.org/) ([litCoffee](http://litcoffee.org/)) application

##main(bootstrap)
This is the *main* application bootstrapping file that sets
up the web server and defines routes.

####Include external packages
	
external package requirements are defined in package.json
in this same root directory

[Express](http://expressjs.com/) is our web server

	express = require 'express'

##Config
This will allow us to store basic configuration details, like
database connections, or WSDLs based on the specific environment
(e.g. 'development', 'production', 'staging', etc.)

	config = require('./config.json')[app.get('env')]

Routes allows us to map the URL into a handled request

	routes = require './routes'
	user = require './routes/user'

Http provides http protocol api

	http = require 'http'
	path = require 'path'

#app
app is our reference to the webserver

	app = express()

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

Instruct the app to use some basic webserver functionality

	app.use express.favicon()
	app.use express.responseTime()
	app.use express.logger 'dev'
	app.use express.bodyParser()
	app.use express.methodOverride()

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
	app.use express.static path.join __dirname, 'public'

If we are in the development environment, then we enable error handling

	if 'development' == app.get('env')
		app.use express.errorHandler()

##Routs
	
	app.get '/', routes.index
	app.get '/users', user.list

##Port(get)
Get the port number the application will be listening to

	port = app.get 'port'

#CreateServer
Construct the http server by passing a reference to the app then
register for listen events on that port.

	http.createServer(app).listen port, ->
		console.log "Express server listening on port #{port}"
