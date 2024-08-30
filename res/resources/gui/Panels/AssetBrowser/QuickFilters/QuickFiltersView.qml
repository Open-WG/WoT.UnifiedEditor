import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls.Details 2.0

RowLayout {
	id: row
	spacing: 0

	QuickFiltersClearButton {
		Layout.margins: ControlsSettings.padding
		Layout.rightMargin: 0
		Layout.alignment: Qt.AlignTop
	}
	
	Flow {
		id: flow
		spacing: ControlsSettings.spacing

		Layout.margins: ControlsSettings.padding
		Layout.fillWidth: true

		Repeater {
			id: repeater
			model: QuickFiltersModel {}
			delegate: QuickFilterDelegate {}
		}
	}
}
