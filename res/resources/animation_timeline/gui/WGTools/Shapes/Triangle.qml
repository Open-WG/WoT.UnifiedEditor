import QtQuick 2.7

Canvas {
	property color color

	// renderTarget: Canvas.FramebufferObject
	// renderStrategy: Canvas.Cooperative

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
		ctx.lineTo(width / 2, height)
		ctx.closePath()
		ctx.fillStyle = color
		ctx.fillRule = Qt.WindingFill
		ctx.fill()
	}
}
