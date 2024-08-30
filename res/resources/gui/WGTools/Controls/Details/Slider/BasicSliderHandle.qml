import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Control {
	id: handle
	z: 1

	property string src

	contentItem: Image {
		property color __strokeColor: control.enabled ? _palette.color1 : _palette.color5
		property color __fillColor: __visualFocus
			? _palette.color12
			: control.enabled
				? _palette.color1
				: _palette.color5

		property bool __visualFocus: control.visualFocus || handle.visualFocus

		source: src
			+ "?fill-color=" + encodeURIComponent(__fillColor)
			+ "&stroke-color=" + encodeURIComponent(__strokeColor)

		ColorBehavior on __fillColor {}
		ColorBehavior on __strokeColor {}
	}
}
