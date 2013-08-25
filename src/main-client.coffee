socket = io.connect('http://localhost:3000')

wrapMessage = (str) ->
	return {message: str}

htmlEncode = (value) ->
	return $('<div/>').text(value).html()

htmlDecode = (value) ->
	return $('<div/>').html(value).text()

socket.on 'onConnect', (data) ->
	console.log data
	$("#chat-history").append "<p class='on-connect'><span class='message'> #{htmlEncode(data.message)}:</span> #{data.date}</p>"
	socket.emit 'onConnect', wrapMessage('client connected:')

socket.on 'updateChat', (data) ->
	self = data.username == socket.username ? 'self' : ''
	$chatHistory = $ "#chat-history"
	$chatHistory.append "<p class='chat'><span class='username #{self}'>#{htmlEncode(data.username)}</span>: #{htmlEncode(data.message)}</p>"
	$chatHistory.scrollTop $chatHistory[0].scrollHeight

socket.on 'newUser', (data) ->
	$chatHistory = $ "#chat-history"
	$chatHistory.append "<p class='new-user'><span class='username'>#{htmlEncode(data.message)}</span> has joined the conversation.</p>"
	$chatHistory.scrollTop $chatHistory[0].scrollHeight
	if socket.username == data.message
		$("#authenticate").hide 'slow'
		$("#chat").show 'slow'
		$("#chat-input").focus()

$ ->
	$("#login-form input[name='username']").focus()

	$("#login-form").submit (e) ->
		e.preventDefault()
		name = $("#login-form input[name='username']").val()
		if name
			socket.username = name
			socket.emit 'setName', wrapMessage(name)

	$("#chat-input-form").submit (e) ->
		e.preventDefault()
		$chatInput = $("#chat-input")
		message = $chatInput.val()
		$chatInput.val ''
		socket.emit 'onChat', wrapMessage(message)
