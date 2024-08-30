import QtQuick 2.7

QtObject {
	id: factory
	objectName: "" + factory

	property var choiceCriteria
	property var properties
	property Component component

	function create(context) {
		if (component == null)
		{
			console.log("Error creating object: Component has not been set.")
			return null
		}
		
		if (component.status == Component.Error)
		{
			console.log("Error creating object: " + component.errorString())
			return null
		}

		var object = component.createObject(null, _getProperies(context))
		if (object == null)
		{
			console.log("Error creating object")
			return null
		}

		return object
	}

	function reuse(object, context) {
		_setProperties(object, _getProperies(context))
	}

	function _getProperies(context) {
		switch (typeof properties)
		{
			case "object":
				return properties

			case "function":
				return properties(context)

			default:
				return {}
		}
	}

	function _setProperties(object, properties) {
		for (var key in properties)
		{
			if (typeof object[key] == "undefined")
			{
				continue
			}

			switch (typeof properties[key])
			{
				case "undefined":
					switch (typeof object[key])
					{
						case "string":
							object[key] = ""
							break

						case "boolean":
							object[key] = false
							break

						case "number":
							object[key] = NaN
							break

						default:
							object[key] = undefined
							break
					}
					break

				case "function":
					object[key] = properties[key]
					break

				default:
					object[key] = Qt.binding(function() { return properties[key] })
					break
			}
		}
	}
}
