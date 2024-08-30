import QtQuick 2.11

QtObject {
	property var parent: null
	readonly property real value: {
		let w = -1
		
		if (parent == null) {
			return w
		}

		for (var i=0; i<parent.count; ++i) {
			let item = parent.itemAt(i)
			w = Math.max(w, item.implicitWidth)
		}
		return w
	}
}
