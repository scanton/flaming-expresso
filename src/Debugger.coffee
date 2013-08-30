module.exports = class Debugger
	constructor: (@io = null) ->
	@log: (obj) ->
		if @io
			@io.sockets.emit 'debug', data: obj
		console.log obj
	@setIo: (@io) ->
	@getIo: -> @io