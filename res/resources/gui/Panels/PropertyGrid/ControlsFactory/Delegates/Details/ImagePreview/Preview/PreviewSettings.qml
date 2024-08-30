import QtQuick 2.10

QtObject {
	property bool red: true
	property bool green: true
	property bool blue: true
	property bool alpha: false
	readonly property int enabledChannels: (red ? 1 : 0) + (green ? 1 : 0) + (blue ? 1 : 0) + (alpha ? 1 : 0)

	property bool checkerboard: true
	property color backgroundColor: "transparent"

    // properties for atlas
    property real zoomFactor: 1.0
    property int tileType: 0

	function reset() {
		red = true
		green = true
		blue = true
		alpha = false

		checkerboard = true
		backgroundColor = "transparent"
	}
}
