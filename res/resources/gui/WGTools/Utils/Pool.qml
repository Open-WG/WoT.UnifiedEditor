import QtQuick 2.7

QtObject {
	id: pool

	property var factory
	property var _records: new Object()
	property var _recordCount: 0

	readonly property alias size: pool._recordCount

	function create(context) {
		var object = null

		if (typeof factory != "object")
		{
			console.log("Error: invalid factory type.")
			return
		}

		for (var recordKey in _records)
		{
			var record = _records[recordKey]

			if (record.free)
			{
				object = record.object
				record.free = false

				if (typeof factory["reuse"] == "function")
				{
					factory.reuse(object, context)
				}

				break
			}
		}

		if (object == null)
		{
			object = factory.create(context)
			if (object)
			{
				var recordKey = _getRecordKey(object)
				_records[recordKey] = {'object': object, 'free': false}
				_recordCount++
			}
		}

		return object
	}

	function release(object) {
		var recordKey = _getRecordKey(object)

		if (typeof _records[recordKey] != "undefined")
		{
			var record = _records[recordKey]
			record.object.parent = null
			record.free = true

			return true
		}
		
		return false
	}

	function clear() {
		var removeKeys = []

		for (var recordKey in _records)
		{
			if (_records[recordKey].free)
			{
				_records[recordKey].object.destroy()
				_recordCount--

				removeKeys.push(recordKey)
			}
		}

		removeKeys.forEach(function(recordKey) {
			delete _records[recordKey]
		})
	}

	function _getRecordKey(object) {
		return "" + object
	}

	Component.onDestruction: {
		clear()
	}
}
