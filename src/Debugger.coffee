module.exports = class Debugger

	@io = null

	constructor: () ->

	@log: (obj) ->
		if @io
			@io.sockets.emit 'debug', obj
		console.log '\n\n*********\n'
		console.log obj
		console.log '\n\n'
