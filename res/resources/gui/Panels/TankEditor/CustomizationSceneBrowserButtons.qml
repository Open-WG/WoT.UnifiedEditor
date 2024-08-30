import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

ColumnLayout {

	RowLayout {
		Layout.fillWidth: true

		Repeater {
			model: panelContext.buttonsModel

			Button {
				Layout.fillWidth: true
				focusPolicy: Qt.StrongFocus

				text: model.name
				icon.source: model.icon
				onClicked: model.onClicked
			}
		}
	}
}
