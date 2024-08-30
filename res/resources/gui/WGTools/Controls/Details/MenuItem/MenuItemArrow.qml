import QtQuick 2.11
import QtQuick.Controls.impl 2.3 as Impl

Impl.ColorImage {
	x: control.width - width - control.rightPadding
	y: control.topPadding + (control.availableHeight - height) / 2

	visible: control.subMenu
	mirror: control.mirrored
	source: control.subMenu ? "image://gui/icon-submenu" : ""
	color: _palette.color2
	defaultColor: "#353637"
}
