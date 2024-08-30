import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import "../SpinBox"

RowLayout {
	id: layout
	spacing: ControlsSettings.spacing
	Accessible.name: "RGB"
	
 	Repeater {
 		id: repeater
 		model: delegateRoot.propertyData != undefined ? 3 : null

		SpinBox {
			implicitWidth: 40
			padding: 0
			spacing: ControlsSettings.spacing
			topPadding: 0
			bottomPadding: 0
			background: null
			buttonsVisible: false
			font.bold: true
			
			label.text: ["R", "G", "B"][index]
			label.color: _palette.color3
			Accessible.name: label.text

			from: 0
			to: [255, 255, 255][index]

			valueData: delegateRoot.propertyData.valueElements[index]
			value: [delegateRoot.rgb.r, delegateRoot.rgb.g, delegateRoot.rgb.b][index] * to

			Layout.fillWidth: true
			KeyNavigation.left: index > 0 ? repeater.itemAt(index - 1) : null;

			// to prevent handling keys input in parent control
			Keys.priority: Keys.AfterItem
			//Keys.onPressed: event.accepted = true
		}
	}
}
