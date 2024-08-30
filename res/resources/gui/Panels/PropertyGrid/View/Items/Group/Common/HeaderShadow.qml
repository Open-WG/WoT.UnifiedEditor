import QtQuick 2.11
import WGTools.Controls.impl 1.0
import QtGraphicalEffects 1.0

DropShadow {
	id: shadow
	cached: true
	color: Color.transparent(_palette.color10, 0.25)
	radius: 4
	samples: radius * 1.5
	transparentBorder: true
	verticalOffset: 2
	horizontalOffset: 0
}
