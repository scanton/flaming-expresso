#app-client ![litCoffee Logo](https://raw.github.com/scanton/flaming-expresso/master/public/images/litCoffee-icon.png)
##main (bootstrap) **CLIENT**
This is the main application bootstraping on the client side.

##socket
We start by defining our web socket connection *socket*.  This URL should be edited to match the location/port of your FlamingExpresso server.

	socket = io.connect 'http://localhost:3000'

Make the socket available globally to the application by attaching it to the window.

	window.socket = socket

#trace (socket.io tracer) global
Make a shortcut to socket.io debugging.

	window.trace = (obj) ->
		socket.emit 'debug', obj

##helper functions
These are a few utility functons that are used later in this file:

####wrapMessage
This is just a hookpoint to intercept a message before it gets sent to the server.  If we wanted to send other data (like a timestamp or game data), we could add that information into this generic object created in *wrapMessage*

	wrapMessage = (str) ->
		return {message: str}

####htmlEncode
This is a quick trick to use jQuery built in HTML encoding to sanitize a string.

	htmlEncode = (value) ->
		return $('<div/>').text(value).html()

####htmlDecode
This is the same trick like *htmlEncode* above.  We are using jQuery to htmlDecode a string that is HTML encoded.

	htmlDecode = (value) ->
		return $('<div/>').html(value).text()

#Web Socket events

##onConnect (event)
onConnect is triggered when the cliet successfully connects to the FlamingExpresso server.  All we are doing is outputting the data sent to the onConnect event to the console.  We then append the chat history showing the user that they have connected to a chat session.

	socket.on 'onConnect', (data) ->
		console.log data
		$("#chat-history").append "<p class='on-connect'><span class='message'> #{htmlEncode(data.message)}:</span> #{data.date}</p>"
		socket.emit 'onConnect', wrapMessage('client connected:')

##updateChat (event)
updateChat is triggered when a user sends a new message to a chat session.  We determine if the update came from the current user and then update the chatHistory div by appending the new message to the view.  Finally, we scroll the chatHistory to the bottom of the page showing the most recent messages at the bottom.

	socket.on 'updateChat', (data) ->
		self = data.username == socket.username ? 'self' : ''
		$chatHistory = $ "#chat-history"
		$chatHistory.append "<p class='chat'><span class='username #{self}'>#{htmlEncode(data.username)}</span>: #{htmlEncode(data.message)}</p>"
		$chatHistory.scrollTop $chatHistory[0].scrollHeight

##newUser (event)
newUser is triggered when a new user connects to a chat session.

We update the chatHistory to let everyone know that the new user has joined the chat.  Also, if the newUser event came from the current client (e.g. socket.username == data.message), we update the webpage to remove the login login form and display the chat views.

	socket.on 'newUser', (data) ->
		$chatHistory = $ "#chat-history"
		$chatHistory.append "<p class='new-user'><span class='username'>#{htmlEncode(data.message)}</span> has joined the conversation.</p>"
		$chatHistory.scrollTop $chatHistory[0].scrollHeight
		if socket.username == data.message
			$("#authenticate").hide 'slow'
			$("#chat").show 'slow'
			$("#chat-input").focus()

##debug (event)
debug is triggered when the socket server is triggered by the server side Debugger

	socket.on 'debug', (data) ->
		console.log data

#jQuery
*$ ->* is the jQuery **$(document).ready()** event handler.  When the document has fully loaded (images and other assets may not have loaded yet, but the document has) this code will be executed in the browser.

	$ ->

Our current home page is fairly simple.  We make it even more simple my focusing the cursor on the login-form inputs

		$("#login-form input[name='username']").focus()

When the login form is submitted, we intercept that event (so the page does not refresh), and then emit 'setName' into our *socket* to let other users know our chat name.

*note:* currently there is no authentication.  A user can set their name to anything including names other users are currently using.  This will change later.

		$("#login-form").submit (e) ->
			e.preventDefault()
			name = $("#login-form input[name='username']").val()
			if name
				socket.username = name
				socket.emit 'setName', wrapMessage(name)

When the user submits the chat input form, we intercept the event to prevent page refresh.  We then clean up the UI (removing the message from the chat input) and emit the onChat event to the *socket* which sends the message to everyone listening, including the client sending the message.

		$("#chat-input-form").submit (e) ->
			e.preventDefault()
			$chatInput = $ "#chat-input"
			message = $chatInput.val()
			$chatInput.val ''
			socket.emit 'onChat', wrapMessage(message)
