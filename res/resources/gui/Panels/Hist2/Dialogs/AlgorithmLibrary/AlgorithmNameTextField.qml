import QtQuick 2.11
import WGTools.Controls 2.0

TextField {
	id : input

	validator: RegExpValidator {
		// Validate algorithm name as XML tag
		regExp: /^(?![Xx][Mm][Ll])^[A-Za-z_][\w\.\-]+/
	}

	function algorithmNameAccepted() {
		return true;
	}

	onActiveFocusChanged: {
		if (!activeFocus) {
			visible = false;
			errorToolTip.visible = false;
			editingFinished();
		}
	}

	Keys.onPressed: {
		if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
			if (!algorithmNameAccepted()) {
				errorToolTip.visible = true;
			} else {
				focus = false;
			}

			event.accepted = true;
		} else if (event.key == Qt.Key_Escape) {
			focus = false;
		}
	}

	Rectangle {
		id: errorToolTip
		anchors.top: parent.bottom
		width: parent.width
		height: errorMessge.contentHeight
		visible: false
		color: "firebrick"

		Text {
			id: errorMessge
			anchors.fill: parent
			wrapMode: Text.WordWrap
			color: parent.parent.color
			text: "Please enter unique algorithm name."
		}
	}

	z: 1 // Show text edit over list item
}