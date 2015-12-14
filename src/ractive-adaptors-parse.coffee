Ractive = require "ractive"
Parse = require("parse")
EventEmitter = require "events"

eventManager = new EventEmitter()

module.exports = adaptor =
		Parse: Parse = require("parse") or null
		
		filter: (obj) ->
			throw new Error "Could not find Parse. You must do `adaptor.Parse = Parse` - see https://github.com/cprecioso/ractive-adaptor-ractive#installation for more information" unless @Parse?.Object?
			obj instanceof @Parse.Object
			Parse = @Parse
		wrap: (ractive, object, keypath, prefixer) ->
			new WrappedParseObject ractive, object, keypath, prefixer

class WrappedParseObject
	### Methods to replace ###
	wrappedSet: (key, value) ->
		retVal = Parse.Object::set.apply @, arguments
		if !!retVal
			eventManager.emit(@className + "-" + @id, @, key)
		return retVal
	
	eventListener: (ractive, prefixer, desiredTarget) -> (target, key) => if target is desiredTarget
		ractive.set prefixer if key is false
				@::get.apply target
			else "#{key}": target.get "key"
	
	### Wrap Parse Object ###
	constructor: (@ractive, @object, keypath, prefixer) ->
		object.set = @::wrappedSet
		
		@listener = [
			@object.className + "-" + @object.id,
			@eventListener ractive, prefixer, @object
		]
		eventManager.addListener @listener...
	
	### Ractive Wrapper methods ###
	get: -> @object.attributes
	set: (key, value) -> previousSet.call @object, key, value
	teardown: ->
		eventManager.removeListener @listener...
		delete @object.set
	reset: -> false

require("ractive")?.adaptors.Parse = adaptor