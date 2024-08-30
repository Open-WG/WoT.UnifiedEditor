import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0

Pane {
	id: pane

	default property alias _data: layout.data
	property bool fill: false

	padding: 10

	contentData: RowLayout {
		id: layout
		width: pane.fill ? pane.availableWidth : Math.min(implicitWidth, pane.availableWidth)
		layoutDirection: Qt.RightToLeft
		spacing: 5

		anchors.right: parent.right
	}
}
