import QtQuick 2.11
import WGTools.Controls 2.0 as Controls
import QtQuick.Controls 2.4 as TControls

Rectangle {
	property var id: "Lock Files"
	property var title: "Lock space"

	implicitWidth: 540
	implicitHeight: 236

	color: _palette.color8

	TControls.ScrollView {
		anchors.margins: 10
		anchors {
			top: parent.top
			left: parent.left
			right: parent.right
			bottom: footer.top
		}

		Controls.TextArea {
			placeholderText: "Jira task number, description"

			onEditingFinished: {
				console.log("text cahnged")
				context.message = text
			}
		}
	}

	Rectangle {
		id: footer
		color: _palette.color8
		implicitHeight: 40
		anchors.bottom: parent.bottom
		anchors.left : parent.left
		anchors.right : parent.right

		Rectangle {
			id: separator
			color: _palette.color5
			width: parent.width
			height: 1
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
		}

		Controls.Button {
			text: "Back to minimap"
			anchors.left: parent.left
			anchors.leftMargin: 10
			anchors.verticalCenter: parent.verticalCenter
			implicitWidth: 100
			implicitHeight: 20

			onClicked: context.back()
		}

		Controls.Button {
			text: "Lock"
			anchors.right: parent.right
			anchors.rightMargin: 10
			anchors.verticalCenter: parent.verticalCenter
			implicitWidth: 50
			implicitHeight: 20

			onClicked: context.lock()
		}
	}
}