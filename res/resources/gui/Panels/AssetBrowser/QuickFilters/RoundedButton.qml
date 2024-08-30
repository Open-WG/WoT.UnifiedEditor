import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0 as Details

Button {
	id: control
	background: Details.ButtonBackground {
		id: clipper
		color: "transparent"
		clip: true

		Details.ButtonBackground {
			id: clipped
			width: parent.width
			height: parent.height
		}
	}

	function setLeftRounded() {
		clipped.width = Qt.binding(function() { return clipper.width + clipper.radius * 2 })
		clipped.anchors.left = Qt.binding(function() { return clipper.left })
	}

	function setRightRounded() {
		clipped.width = Qt.binding(function() { return clipper.width + clipper.radius * 2 })
		clipped.anchors.right = Qt.binding(function() { return clipper.right })
	}

	function setBothRounded() {
		clipped.width = Qt.binding(function() { return clipper.width })
		clipped.anchors.fill = Qt.binding(function() { return clipper })
	}
}
