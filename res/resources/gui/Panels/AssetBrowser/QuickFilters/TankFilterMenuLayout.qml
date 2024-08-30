import QtQuick 2.7
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

RowLayout
{
	property alias model: repeater.model

	id: layout
	spacing: 0

	Flow {
		id: flow
		spacing: ControlsSettings.spacing

		Layout.margins: ControlsSettings.padding
		Layout.fillWidth: true

		Repeater {
			id: repeater
			delegate: QuickFilterDelegate {
				useFilter: false

				Component.onCompleted: {
					useFilter = Qt.binding(function() { return tankFilterMenu.active })
				}
			}
		}
	}

	function hasChecked() {
		for (var i = 0; i < repeater.count; ++i) {
			if (repeater.itemAt(i).checked) {
				return true
			}
		}
		return false
	}

	function clear() {
		for (var i = 0; i < repeater.count; ++i) {
			repeater.itemAt(i).removeFilter(false)
		}
	}
}
