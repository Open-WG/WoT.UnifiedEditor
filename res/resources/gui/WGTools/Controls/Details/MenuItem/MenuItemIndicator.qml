import QtQuick 2.11
import QtQuick.Controls.impl 2.3 as Impl

Item {
	width: Math.max(img.implicitWidth, control.icon.width != undefined ? control.icon.width : 0)
	height: Math.max(img.implicitHeight, control.icon.height != undefined ? control.icon.height : 0)
	x: control.leftPadding
	y: control.topPadding + (control.availableHeight - height) / 2
	visible: control.checked

	Impl.ColorImage {
		id: img
		x: (parent.width - width) / 2
		y: (parent.height - height) / 2
		source: "image://gui/icon-check"
		color: control.icon.color
	}
}
