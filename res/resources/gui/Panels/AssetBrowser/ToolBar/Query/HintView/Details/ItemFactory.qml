import QtQuick 2.7

QtObject {
	id: contentItemsPool

	property Component delegate
	property var privateObjects: []
	property int debugCreatedCount: 0

	function createObject(parent, properties) {
		var object = null

		if (privateObjects.length > 0)
		{
			object = privateObjects.pop()

			for (var key in properties)
				object[key] = Qt.binding(function() { return properties[key] })
		}
		else
		{
			object = delegate.createObject(null, properties)
			++debugCreatedCount
		}

		object.parent = parent
		return object
	}

	function removeObject(object) {
		object.parent = null
		privateObjects.push(object)
	}
}
