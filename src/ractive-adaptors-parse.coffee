Ractive = require "ractive"
EventEmitter = require "events"

eventManager = new EventEmitter()
initKey = "__ractiveParseAdaptor__initialized__"
previousSet = ->

module.exports = adaptor =
		Parse: require("parse") or null
		
		init: ->
			throw new Error "Could not find Parse. You must do `adaptor.Parse = Parse` - see https://github.com/cprecioso/ractive-adaptor-ractive#installation for more information" unless @Parse?.Object?.prototype?.set?
			return if @Parse[initKey]
			previousSet = Parse.Object.prototype.set
			Parse.Object.prototype.set = (key, value, options) ->
				retVal = previousSet.apply @, arguments
				if !!retVal
					eventManager.emit(@className + "-" + @id, key, value)
				return retVal
			@Parse[initKey] = true
		
		filter: (obj) ->
			throw new Error "Could not find Parse. You must do `adaptor.Parse = Parse` - see https://github.com/cprecioso/ractive-adaptor-ractive#installation for more information" unless @Parse?.Object?.prototype?.set?
			obj instanceof @Parse.Object
		wrap: (ractive, object, keypath, prefixer) ->
			@init()
			new WrappedParseObject ractive, object, keypath, prefixer

class WrappedParseObject
	constructor: (ractive, @object, keypath, prefixer) ->
		@listener = [
			@object.className + "-" + @object.id,
			do (ractive, prefixer) ->
				(key, value) -> ractive.set prefixer "#{key}": value
		]
		eventManager.addListener @listener...
	
	get: -> @object.attributes
	set: (key, value) -> previousSet.call @object, key, value
	teardown: -> eventManager.removeListener @listener...
	reset: -> false

require("ractive")?.adaptors.Parse = adaptor