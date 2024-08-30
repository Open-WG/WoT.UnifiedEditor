import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0
import WGTools.Controls.Controllers 1.0
import "Details/SpinBox" as Details
import WGTools.PropertyGrid 1.0 as PG

RangeDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: delegateRoot.enabled

	RowLayout {
		id: layout
		width: parent.width
		height: parent.height

		Details.RangeSpinBox {
		}

		RangeSlider {
			id: slider
			wheelEnabled: activeFocus && propertyGrid.controlsWheelEnabled

			Layout.fillWidth: true
			Layout.fillHeight: true

			Binding on stepSize { value: delegateRoot.propertyData != undefined ? delegateRoot.propertyData : 0 }
			Binding on from { value: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.valueMinSoft : undefined }
			Binding on to { value: delegateRoot.propertyData != undefined ? delegateRoot.propertyData.valueMaxSoft : undefined }
			Binding { target: slider.first; property: "value"; value: delegateRoot.firstValue }
			Binding { target: slider.second; property: "value"; value: delegateRoot.secondValue }

			RangeSliderController {
				onFirstModified: delegateRoot.setFirstValue(slider.first.value, !commit ? PG.IValueData.TRANSIENT : 0)
				onSecondModified: delegateRoot.setSecondValue(slider.second.value, !commit ? PG.IValueData.TRANSIENT : 0)
			}
		}
	}
}
