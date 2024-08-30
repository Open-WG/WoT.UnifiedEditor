import QtQuick 2.11

Loader {
	id: loader

	enum Edge {None, Left, Right, Top, Bottom}
	property int edge

	Binding on edge {value: calculateEdge()}
	Binding on active {value: loader.edge != ToolTipArrowLoader.None}

	onEdgeChanged: switch(edge) {
		case ToolTipArrowLoader.Left:
			x = Qt.binding(function(){return (height - width)/2 - height})
			y = Qt.binding(leftRightY)
			rotation = 90
			break

		case ToolTipArrowLoader.Right:
			x = Qt.binding(function(){return control.width + (height - width)/2})
			y = Qt.binding(leftRightY)
			rotation = -90
			break

		case ToolTipArrowLoader.Top:
			loader.x = Qt.binding(topBottomX)
			loader.y = Qt.binding(function(){return -height})
			loader.rotation = 180
			break

		case ToolTipArrowLoader.Bottom:
			loader.x = Qt.binding(topBottomX)
			loader.y = Qt.binding(function(){return control.height})
			loader.rotation = 0
			break

		default:
			loader.x = 0
			loader.y = 0
			loader.rotation = 0
			break
	}

	function leftRightY() {
		return (width - height)/2 + Math.min(Math.max(0, control.aim.y - width / 2), control.height - width)
	}

	function topBottomX() {
		return Math.min(Math.max(0, control.aim.x - width/2), control.width - width)
	}

	function calculateEdge() {
		if (!control.aim.valid)
			return ToolTipArrowLoader.None

		if (control.aim.x < 0)
			return calculateCornerEdge(-control.aim.x, ToolTipArrowLoader.Left)

		if (control.aim.x > control.width)
			return calculateCornerEdge(control.aim.x - control.width, ToolTipArrowLoader.Right)

		return calculateCornerEdge(0, ToolTipArrowLoader.None)
	}

	function calculateCornerEdge(dx, fallbackEdge) {
		if (control.aim.y < 0 && -control.aim.y > dx)
			return ToolTipArrowLoader.Top

		if (control.aim.y > control.height && (control.aim.y - control.height) > dx)
			return ToolTipArrowLoader.Bottom

		return fallbackEdge
	}
}
