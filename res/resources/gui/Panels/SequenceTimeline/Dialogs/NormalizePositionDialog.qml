import QtQuick 2.7
import QtQuick.Layouts 1.3

import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc

import "..//Buttons"
import "..//Constants.js" as Constants

Rectangle {
	id: dialog

	property var title: "Normalize Position Track (Experimental)"
	property int maximumHeight: 175
	property int minimumHeight: 175
	property int maximumWidth: 100
	property int minimiumWidth: 100

	color: _palette.color7

	Accessible.name: title

	MouseArea {
		anchors.fill: parent
		onClicked: forceActiveFocus()
	}

	ColumnLayout {
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
		width: parent.width
		height: parent.height

		RowLayout {
			spacing: 0

			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

			ColumnLayout {
				Misc.Text {
					id: lengthLabel

					padding: 3
					text: "Curve Length:"

					verticalAlignment: Text.AlignVCenter
				}

				Misc.Text {
					id: spinBoxLabel

					padding: 3
					text: "New Time:"

					verticalAlignment: Text.AlignVCenter
				}

				Misc.Text {
					id: autoSplitLabel

					padding: 3
					text: "Auto-Split:"

					verticalAlignment: Text.AlignVCenter
				}
			}

			ColumnLayout {
				Misc.Text {
					text: context.curveLength.toFixed(2)

					verticalAlignment: Text.AlignVCenter
				}

				Controls.DoubleSpinBox {
					id: spinBox

					value: context.time
					from: 0.1
					to: Number.MAX_SAFE_INTEGER

					Layout.preferredHeight: spinBoxLabel.height

					onValueModified: context.time = value
				}

				Controls.CheckBox {
					id: autoSplitCheckBox

					checked: context.autoSplit

					Layout.preferredHeight: autoSplitLabel.height
					onCheckedChanged: context.autoSplit = checked
				}
			}
		}

		Rectangle {
			color: "black"
			height: 1
			Layout.fillWidth: true
		}

		RowLayout {
			Layout.alignment: Qt.AlignHCenter
			
			Controls.Button {
				text: "Ok"

				onClicked: context.accept()
			}

			Controls.Button {
				text: "Cancel"

				onClicked: context.reject()
			}
		}
	}
}
