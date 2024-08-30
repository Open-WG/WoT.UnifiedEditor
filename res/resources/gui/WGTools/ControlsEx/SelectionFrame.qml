import QtQuick 2.10

Rectangle {
	id: item
	color: "#300000FF"
	visible: false

	border.width: 1
	border.color: "#0000FF"

	function show(x, y) {
		item.x = x
		item.y = y
		width = 0
		height = 0
		visible = true
	}

	function resize(x, y) {
		let oldX = item.x
		let oldY = item.y

		item.x = Math.min(x, oldX)
		item.y = Math.min(y, oldY)
		width = Math.abs(x - oldX)
		height = Math.abs(y - oldY)
	}

	function hide() {
		x = -1
		y = -1
		width = 0
		height = 0
		visible = false
	}
}
