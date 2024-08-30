import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc
import WGTools.Debug 1.0

Rectangle {
	id: root

	property var title: "Cubemap Generation"
	property int maximumHeight: implicitHeight
	property int maximumWidth: implicitWidth
	property int minimumHeight: implicitHeight
	property int minimumWidth: implicitWidth

	implicitWidth: 300
	implicitHeight: 75
	color: _palette.color7
	focus: true

	Accessible.name: title

	MouseArea {
		anchors.fill: parent

		onClicked: {
			root.forceActiveFocus()
		}
	}

	ColumnLayout {
		id: mainLayout

		anchors.fill: parent

		Item {
			Layout.leftMargin: 5
			Layout.rightMargin: 5
			Layout.topMargin: 5
			Layout.fillHeight: true
			Layout.fillWidth: true

			Misc.Text {
				id: label
				anchors.verticalCenter: parent.verticalCenter
				text: "Enter number of generation passes:"
			}

			Controls.SpinBox {
				id: spinBox

				anchors.left: label.right
				anchors.right: parent.right
				anchors.verticalCenter: label.verticalCenter
				from: 1
				to: 100
				value: context.numPasses
				editable: true

				onValueModified: {
					context.numPasses = value
				}
			}
		}

		Rectangle {
			Layout.fillWidth: true

			color: "black"
			width: parent.width
			height: 1
		}

		RowLayout {
			Layout.fillWidth: true
			Layout.maximumHeight: 25

			Layout.leftMargin: 5
			Layout.rightMargin: 5
			Layout.bottomMargin: 5
			
			Layout.alignment: Qt.AlignRight
			
			Controls.Button {
				Layout.preferredWidth: 50
				text: "Ok"

				onClicked: context.accept()
			}

			Controls.Button {
				Layout.preferredWidth: 50
				text: "Cancel"

				onClicked: context.cancel()
			}
		}
	}
}
