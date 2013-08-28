#RouteUtils

Since we have some extra requirements for our routing system,
we are not replacing the Express router (it is used by other parts)
of the application.  But our primary routing that includes
possible replicated website data, region-language data or other
parameters unique to our business requires a more active hand
on how the URI is parsed.

RouteUtils parses the requested URI and provides an abstracted api 
to work with the URI.

	module.exports = class RouteUtils

		@hasAssociate = false
		@assoc = ''
		@region = ''
		@language = ''
		@page = ''
		@index = ''

##constructor
The constructor requires the following parameters

* @req - the Express req object
* @regExLib - a reference to the RegExLibrary class
* @serviceAdapter - a reference to a serviceAdapter such as the ProxyServiceAdapter class

		constructor: (@req, @regExLib, @serviceAdapter) ->
			@init()

#init
We set up some inital properties that we will use in this class

* @argIndex will help us keep track of which URI parameters have already been identified, so we only focus on ones we are not sure of yet
* @linkPath will hold the elements of our path used for the getLink function
* @args will hold a list of arguments found in the URI
* @path is and array of the request URI split by slashes '/'

		init: ->
			@argIndex = 0
			@linkPath = []
			@args = []
			@path = @req.path.split '/'

In most cases, the first item in this list will always be an empty
string.  If it is, we shift it out of the array to keep from dealing
with it.

			if @path[0] == ''
				@path.shift()

We use our RegExLibrary to test elements in the @path array as
possible parameters.  The first one we test is if the first element
contains associate replicated website data.

			if @regExLib.assoc.test @path[0]

We have a string that could be associate data, so we pass it to
the getAssoc method of @serviceAdapter.  

				assocData = @serviceAdapter.getAssoc @path[0]
				if assocData

If we have valid associate website data, then we know this is a replicated website, so we save our data, update @argIndex to indicate that the first element in the @path has been determined.

					@assoc = @path[0]
					@argIndex = 1
					@hasAssociate = true
					@assocData = assocData
					@linkPath.push @assoc

##getLink
This method is used in links throughout the application to render paths with associate and region-language data.  We will probably create a shorter reference to this method in the main application.

		getLink: (link) ->
			return "#{@linkPath.join('/')}/#{link}"