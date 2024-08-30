import QtQml 2.11

QtObject {
	property bool active: false
	property real x1: 0
	property real x2: 0
	property real y1: 0
	property real y2: 0

	readonly property real minX: Math.min(x1, x2)
	readonly property real minY: Math.min(y1, y2)
	readonly property real width: Math.abs(x1 - x2)
	readonly property real height: Math.abs(y1 - y2)
}
