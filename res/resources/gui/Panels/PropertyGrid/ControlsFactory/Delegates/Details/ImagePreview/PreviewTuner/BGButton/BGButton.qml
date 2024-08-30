import QtQuick 2.10
import WGTools.Controls 2.0

Button {
	id: control
	property color color
	topPadding: padding
	bottomPadding: padding
	rightPadding: indicator.width + spacing + padding

	indicator: BGButtonIndicator {}
	contentItem: BGButtonContent {}
	background: BGButtonBackground {color: control.color}
}
