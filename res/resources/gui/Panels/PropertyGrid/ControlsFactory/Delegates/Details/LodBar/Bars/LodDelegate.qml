import QtQuick 2.7

FocusScope {
	id: control
	clip: true

	property real padding: 5
	readonly property alias hovered: background.containsMouse;
	readonly property alias editing: contentItem.editing

	onActiveFocusChanged: {
		contentItem.editing = activeFocus
	}

	LodDelegateBackground {
		id: background
		onClicked: {
			control.forceActiveFocus(Qt.MouseFocusReason)
			contentItem.editing = true
		}
	}

	LodDelegateContent {
		id: contentItem
		focus: true
	}

	LodDelegateFrame {
	}
}
