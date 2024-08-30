import QtQuick 2.7

QtObject {
	id: mgr

	property list<QtObject> factories
	default property alias _factoriesProperty: mgr.factories

	property var chooser: function(factory, context) { return false }
	property var objectPool: null /* MultiPool {
		factories: mgr.factories
	} */ // TODO: refactor Pool to fix WOTCC-10799 correctly

	function create(context, explicitFactory /*optional*/) {
		var object = null
		var factoryIndex = _findFactory(context, explicitFactory)

		if (factoryIndex != -1)
		{
			if (objectPool)
			{
				object = objectPool.create(factoryIndex, context)
			}

			if (object == null)	// in case when poolManager is not set
			{
				object = factories[factoryIndex].create(context)
			}
		}

		return object
	}

	function release(object) {
		if (objectPool)
		{
			var success = objectPool.release(object)
			
			if (!success)
			{
				console.log("Error: object '" + object + "' has not been released.")
			}
		}
		else
		{
			// in case when poolManager is not set
			object.destroy()
		}
	}

	function _findFactory(context, explicitFactory) {
		var factoryIndex = _findFactoryByName(explicitFactory)

		if (factoryIndex == -1)
			factoryIndex = _findFactoryByContext(context)
		
		return factoryIndex
	}

	function _findFactoryByContext(context) {
		for (var i in factories)
		{
			var factory = factories[i]
			var isProper = false

			switch (typeof chooser)
			{
				case "function":
					isProper = chooser(factory, context)
					break

				case "object":
					console.assert(typeof chooser["check"] == "function")
					isProper = chooser.check(factory, context)
					break
			}

			if (isProper)
			{
				return i
			}
		}

		return -1
	}

	function _findFactoryByName(explicitFactory) {
		if (explicitFactory != null)
		{
			for (var i in factories)
			{
				var factory = factories[i]
				if (factory.objectName == explicitFactory)
					return i
			}
		}

		return -1
	}
}
