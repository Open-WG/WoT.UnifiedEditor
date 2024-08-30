import QtQuick 2.11
import WGTools.Shapes 1.0

Canvas {
	property color color: "#E0E0E0"

	implicitWidth: 6
	implicitHeight: 9

	onColorChanged: requestPaint()
	onWidthChanged: requestPaint()
	onHeightChanged: requestPaint()
	
	onPaint: {
		if (width == 0 || height == 0)
			return

		var ctx = getContext("2d")

		ctx.reset()
		ctx.moveTo(0, 0)
		ctx.lineTo(width, 0)
		ctx.lineTo(width, height * 1/3)
		ctx.lineTo(0, height)
		ctx.closePath()
		ctx.fillStyle = color
		ctx.fillRule = Qt.WindingFill
		ctx.fill()
	}
}
