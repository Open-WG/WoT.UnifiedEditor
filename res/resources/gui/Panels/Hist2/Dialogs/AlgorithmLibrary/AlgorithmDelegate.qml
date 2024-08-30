import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Views.Details 1.0

Button {
	id: control

	width: parent.width
	height: 22
	focusPolicy: Qt.ClickFocus
	
	contentItem: Label {
		elide: Text.ElideRight
		verticalAlignment: Text.AlignVCenter
		text: model.name

		Layout.fillWidth: true
		Layout.fillHeight: true
	}

	background: RowDelegate {
		height: control.height

		property QtObject styleData: QtObject {
			readonly property bool hovered: control.hovered
			readonly property bool selected: control.ListView.isCurrentItem
		}
	}
}
