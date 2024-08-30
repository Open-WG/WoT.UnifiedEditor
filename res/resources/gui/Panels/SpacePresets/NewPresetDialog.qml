import QtQuick 2.11
import QtQuick.Controls 1.4 as QuickControls1
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details

Rectangle {
	color: _palette.color8

	implicitWidth: 400
	implicitHeight: 120

	ColumnLayout {
		id: layout
		anchors.fill: parent
		anchors.margins: 10
		spacing: 5

		RowLayout {
			Controls.TextField {
				Layout.fillWidth: true
				text: context.storageFileName
				readOnly: true
			}

			Controls.Button {
				icon.source: "image://gui/controls-folder"
				onClicked: context.showStorageFile()
			}
		}

		RowLayout {
			QuickControls1.Label {
				text: "Preset Name:"
			}
			Controls.TextField {
				id: presetName
				Layout.fillWidth: true
				text: context.presetName
				onEditingFinished: {
					context.presetName = text
				}
			}
		}

		Item { // spacer
			Layout.fillHeight: true
		}

		RowLayout {
			Item { // spacer
				Layout.fillWidth: true
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				enabled: presetName.text.length > 0
				text: "Add Preset"
				onClicked: context.accept()
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Cancel"
				onClicked: context.reject()
			}
		}
	}
}
