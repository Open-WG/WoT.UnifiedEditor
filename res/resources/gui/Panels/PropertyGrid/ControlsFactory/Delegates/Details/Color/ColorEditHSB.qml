import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import "../SpinBox"

RowLayout {
	id: layout
	spacing: ControlsSettings.spacing
	Accessible.name: "HSV"
	
 	Repeater {
 		id: repeater
 		model: delegateRoot.propertyData != undefined ? 3 : null

		SpinBox {
			readonly property var normalizedValue: value / to
			
			modifiedFunction: function(commit) {
				var h = repeater.itemAt(0)
				var s = repeater.itemAt(1)
				var v = repeater.itemAt(2)

				var color = Qt.hsva(
					h.normalizedValue,
					s.normalizedValue,
					v.normalizedValue,
					delegateRoot.alphaChannel ? delegateRoot.alphaChannel.value / 100 : 0)
				delegateRoot.setHSB(color, !commit)
			}
			
			implicitWidth: 40
			padding: 0
			spacing: ControlsSettings.spacing
			topPadding: 0
			bottomPadding: 0
			background: null
			buttonsVisible: false

			font.bold: true
			decimals: 0
			stepSize: 1
			from: 0
			to: [360, 100, 100][index]
			label.text: ["H", "S", "B"][index]
			label.color: _palette.color3

			valueData: delegateRoot.propertyData.valueElements[index]

			function customGetter() { // override
				return [delegateRoot.hsb.hsvHue, delegateRoot.hsb.hsvSaturation, delegateRoot.hsb.hsvValue][index] * to
			}
			
			Accessible.name: label.text

			Layout.fillWidth: true
			KeyNavigation.left: index > 0 ? repeater.itemAt(index - 1) : null;

			// to prevent handling keys input in parent control
			Keys.priority: Keys.AfterItem
			Keys.onPressed: event.accepted = true
		}
	}
}
