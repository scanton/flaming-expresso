#RouteUtils (class) ![litCoffee Logo](https://raw.github.com/scanton/flaming-expresso/master/public/images/litCoffee-icon.png)

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
		@args = []

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
			@path = @req.path.toLowerCase().split '/'

In most cases, the first item in this list will always be an empty
string.  If it is, we shift it out of the array to keep from dealing
with it.

			if @path[0] == ''
				@path.shift()
			pathLength = @path.length

We use our RegExLibrary to test elements in the @path array as
possible parameters.  The first one we test is if the first element
contains associate replicated website data.
			
			if pathLength
				if @regExLib.assoc.test @path[0]

##associate data parameter
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

##region-language parameter
We then loop over the first one or two elements in the path (depending on if the first argument was found to be associate data).  In this loop, we're looking for a RegEx
to match the region-language data pattern.  If found, we save the region and language data in the instance of the class, and move the @argIndex to the appropriate
location to start looking for a page controler.
				
				if pathLength
					for i in [@argIndex..Math.min(pathLength, 1)]
						if @regExLib.regionLanguage.test @path[i]
							a = @path[i].split('-')
							@region = a[0]
							@language = a[1]
							@argIndex = i + 1
							break

##page controller parameter
Next we look to see if we can find the parameter that matches our page controller pattern.
				
				if pathLength
					for i in [@argIndex..Math.min(pathLength, 2)]
						if @regExLib.controller.test @path[i]
							@page = @path[i]
							@argIndex = i + 1
							break

##index parameter
The index is always the next item after the page controller (if it exists)

				if pathLength >= @argIndex
					@index = @path[@argIndex]
					++@argIndex

##args
Arguments are any extra parameters that were sent in past the index in the URI.  We store them in their own array, and provide various accessor methods in this class.

				if pathLength >= @argIndex
					@args = @path.slice(@argIndex)
					
##getLink
This method is used in links throughout the application to render paths with associate and region-language data.  We will probably create a shorter reference to this method in the main application.

		getLink: (link) ->
			return "#{@linkPath.join('/')}/#{link}"