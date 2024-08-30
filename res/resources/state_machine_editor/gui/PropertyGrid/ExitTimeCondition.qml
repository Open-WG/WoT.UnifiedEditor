import QtQuick 2.7
import QtQuick.Layouts 1.3

import Controls 1.0 as SMEControls

import "..//"

RowLayout {
	id: root

	property alias enabled: hasExitTimeCheckbox.checked
	property var exitTimeCondition: null

	ColumnLayout {
		SMEControls.Text {
			text: "Has Exit Time"
			color: root.enabled ? "white" : "grey"
		}

		SMEControls.Text {
			text: "Exit Offset (%):"
			Layout.leftMargin: 10
			color: root.enabled ? "white" : "grey"
		}
	}

	ColumnLayout {
		Layout.alignment: Qt.AlignTop

		SMEControls.CheckBox {
			id: hasExitTimeCheckbox
			Layout.maximumHeight: 15
			Layout.maximumWidth: 15
		}

		FloatSpinBox {
			visible: root.enabled
			Layout.fillWidth: true

			Binding on value {
				value: exitTimeCondition ? exitTimeCondition.exitOffset : 0
			}

			onValueModified: {
				exitTimeCondition.exitOffset = value
			}
		}
	}
}
