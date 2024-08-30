import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import Controls 1.0 as SMEControls

SMEControls.Dialog {
	id: dialog

	modal: true
	padding: 5

	standardButtons: Dialog.Ok | Dialog.Cancel

	title: "Delete Parameter"

	contentItem: ColumnLayout {
		Layout.fillWidth: true
		spacing: 0

		SMEControls.Text {
			Layout.fillWidth: true
			Layout.fillHeight: true

			text: "You are about to delete a parameter which is used in at least one transition!"

			wrapMode: Text.WordWrap
		}

		RowLayout {
			spacing: 1

			Layout.alignment: Qt.AlignHCenter

			SMEControls.CheckBox {
				checked: false

				onCheckedChanged: {
					dialog.standardButton(Dialog.Ok).enabled = checked
				}
			}

			SMEControls.Text {
				text: "Remove all conditions with this parameter"
				verticalAlignment: Text.AlignVCenter
			}
		}
	}

	Component.onCompleted: dialog.standardButton(Dialog.Ok).enabled = false
}
