import QtQuick 2.11
import QtQuick.Templates 2.2 as T
import WGTools.Controls 2.0 as Controls
import WGTools.PropertyGrid 1.0
import "Details/Slider" as Details
import "Details/SpinBox" as Details

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: spinbox.implicitWidth
	implicitHeight: spinbox.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	Details.SpinBox {
		id: spinbox
		valueData: propertyData

		label.text: propertyData ? propertyData.prefixData.prefix : ""
		label.concatenate: propertyData ? propertyData.prefixData.concatenate : false
		label.color: propertyData ? (propertyData.prefixData.color != "" ? propertyData.prefixData.color : _palette.color2) : _palette.color2
		labelMouseArea.onClicked: {
			popup.open()
		}
	}

	Controls.Popup {
		id: popup
		modal: true
		
		y: spinbox.height + 5

		closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside | T.Popup.CloseOnReleaseOutside
		onOpened: slider.forceActiveFocus()

		Binding {
			target: popup.background
			property: "color"
			value: _palette.color9
		}

		Details.Slider {
			id: slider
			width: parent.width
			ticks.visible: false
			labels.visible: false
			valueData: spinbox.valueData

			Connections {
				target: slider.controller
				onModified: {
					if (commit) {
						popup.close()
					}
				}
			}
		}
	}
}
