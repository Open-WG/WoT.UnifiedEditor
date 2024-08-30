import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0 as Details
import "../../Settings.js" as Settings

Details.SpinBoxBackground {
	id: control
	implicitWidth: rangeSpinBox.width
	Layout.fillHeight: true

	RowLayout {
		id: rangeSpinBox
		property var valueData
		spacing: 0

		SpinBox {
			id: leftSpinBox
			Accessible.name: "low"
			implicitWidth: Math.round(Settings.widthSpinBox / 2) - separator.width
			valueData: QtObject {
				property var value: delegateRoot.firstValue
				readonly property var decimals: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.decimals : 0
				readonly property var stepSize: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.valueStep : 0
				readonly property var valueMinHard: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.valueMinHard : undefined
				readonly property var valueMaxHard: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.valueMaxHard : undefined
				readonly property var units: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.units : undefined


				function setValue(newValue, setterFlags) {
					delegateRoot.setFirstValue(newValue, setterFlags)
				}
			}

			background: null

			Layout.fillHeight: true
		}

		Rectangle {
			id: separator
			width: 1
			height: ControlsSettings.iconSize
			color: _palette.color5
		}

		SpinBox {
			Accessible.name: "high"
			implicitWidth: Settings.widthSpinBox - leftSpinBox.implicitWidth - separator.width
			valueData: QtObject {
				property var value: delegateRoot.secondValue
				readonly property var decimals: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.decimals : 0
				readonly property var stepSize: delegateRoot.propertyData != undefined ? delegateRoot.propertyData : 0
				readonly property var valueMinHard: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.valueMinHard : undefined
				readonly property var valueMaxHard: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.valueMaxHard : undefined
				readonly property var units: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.units : undefined


				function setValue(newValue, setterFlags) {
					delegateRoot.setSecondValue(newValue, setterFlags)
				}
			}

			background: null

			Layout.fillHeight: true
		}
	}
}
