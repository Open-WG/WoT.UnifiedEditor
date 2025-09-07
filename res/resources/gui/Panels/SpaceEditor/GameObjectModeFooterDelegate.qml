import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

RowLayout {
	property bool isSelection: false

	Image {
		id: iconField
		source: "image://gui/" + model.iconPath
	}
	Text {
		id: countField
		color: _palette.color1
		text: isSelection ? model.selectedCount : model.totalCount
		rightPadding: ControlsSettings.padding * 1.5

		Connections {
			target: panelContext
			onNotifyAll: {
				countField.text = isSelection ? model.selectedCount : model.totalCount
			}
		}
	}
}
