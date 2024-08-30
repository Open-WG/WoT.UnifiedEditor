import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as C1
import WGTools.Controls 2.0 as C2
import "Views" as Views
import "Details" as Details

Rectangle {
	property var title: "Keyboard Shortcuts"

	implicitWidth: 800
	implicitHeight: 600
	color: _palette.color8

	Accessible.name: title

	C1.SplitView {
		orientation: Qt.Horizontal
		anchors.fill: parent

		Views.ActionContextsView {
			focus: true
			width: parent.width * 1 / 3
			model: context.contextModel
			selection: context.contextSelection
			Layout.fillHeight: true
		}

		ColumnLayout {
			width: parent.width * 2 / 3
			spacing: 1
			Layout.fillHeight: true

			Views.ActionsView {
				model: context.actionModel
				Layout.fillWidth: true
				Layout.fillHeight: true
			}

			Details.Footer {
				Layout.fillWidth: true

				C2.Button {
					text: "Reset all to default"
					enabled: context.contextSelection.selectedIndexes.length
					onClicked: context.actionModel.resetAllActionShortcuts()
					Layout.fillWidth: true
				}
			}
		}
	}
}

