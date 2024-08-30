import QtQuick 2.7

Instantiator {
	id: mgr

	property alias factories: mgr.model

	function create(poolIndex, context) {
		var pool = objectAt(poolIndex)
		if (pool)
		{
			return pool.create(context)
		}

		return null
	}

	function release(object) {
		for (var poolIndex = 0; poolIndex < count; ++poolIndex)
		{
			if (objectAt(poolIndex).release(object))
			{
				return true
			}
		}

		return false
	}

	Component.onDestruction: {
		model = null
	}

	Pool {
		factory: modelData
	}
}
