import QtQuick 2.7
import WGTools.Shapes 1.0 as Shapes
import "ViewsSettings.js" as ViewsSettings

Item {
	width: ViewsSettings.branchDelegateSize
	height: ViewsSettings.branchDelegateSize

	Shapes.Triangle {
		width: 10
		height: 5
		color: _palette.color2
		rotation: styleData.isExpanded ? 0 : -90
		anchors.centerIn: parent
	}
}
