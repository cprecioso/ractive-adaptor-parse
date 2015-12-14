Ractive = require "ractive"
Parse = require("parse")
EventEmitter = require "events"

eventManager = new EventEmitter()

module.exports = adaptor =
		Parse: Parse = require("parse") or null
		
		filter: (obj) ->
			throw new Error "Could not find Parse. You must do `adaptor.Parse = Parse` - see https://github.com/cprecioso/ractive-adaptor-ractive#installation for more information" unless @Parse?.Object?
			Parse = @Parse
			obj instanceof @Parse.Object
		wrap: (ractive, object, keypath, prefixer) ->
			new WrappedParseObject ractive, object, keypath, prefixer

class WrappedParseObject
	### Methods to replace ###
	wrappedSet: (key, value) ->
		retVal = Parse.Object::set.apply @, arguments
		if !!retVal
			eventManager.emit(@className + "-" + @id, @, key)
		return retVal
	
	wrappedFetch: (target, forceFetch, options) ->
		@_fetch.apply @, arguments
		.then (object) ->
			eventManager.emit(object.className + "-" + object.id, target, false)
			return user
	
	eventListener: (ractive, prefixer, desiredTarget) -> (target, key) => if target is desiredTarget
		ractive.set prefixer if key is false
				@::get.apply target
			else "#{key}": target.get "key"
	
	### Wrap Parse Object ###
	constructor: (@ractive, @object, keypath, prefixer) ->
		object.set = @::wrappedSet
		objectController = Parse.CoreManager.getObjectController()
		unless objectController.ractiveParseWrapper
			objectController._fetch = objectController.fetch
			objectController.fetch = @::wrappedFetch
			objectController.ractiveParseWrapper = true
		
		@listener = [
			@object.className + "-" + @object.id,
			eventListener @ractive, keypath, prefixer, @object
		]
		eventManager.addListener @listener...
	
	### Ractive Wrapper methods ###
	get: -> @object.attributes
	set: (key, value) -> Parse.Object::set.apply @object, arguments
	teardown: ->
		eventManager.removeListener @listener...
		delete @object.set
	reset: -> false

require("ractive")?.adaptors.Parse = adaptor