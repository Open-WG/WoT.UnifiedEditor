import QtQuick 2.7
import "../../../Common" as Common

Item {
	id: root

	signal pathSelected(string selectedPath)

	width: parent.width
	height: 25
	z: 0.9

	Rectangle {
		width: parent.width
		height: 1
		color: _palette.color2
	}

	Rectangle {
		anchors.fill: parent
		color: _palette.color8
		opacity: 0.85
	}

	Common.PathBreadcrumbsView {
		path: section
		textHeight: 12
		iconHeight: 12
		spacing: 5
		endingSlash: false
		onSelected: root.pathSelected(selectedPath)

		anchors.fill: parent
		anchors.leftMargin: 8
	}
}
