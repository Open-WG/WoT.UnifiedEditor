import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.PropertyGrid 1.0
import "Details/Common" as Details

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null;
	enabled: propertyData && !propertyData.readonly

	Details.ControlPositioner {
		target: control
		data: delegateRoot.model
		fallback.fillHeight: true
	}

	Button {
		id: control
		text: propertyData ? propertyData.button.text : ""
		flat: text == "" && icon.source != ""
		checkable: true

		icon.source: (propertyData && propertyData.button.icon) ? "image://gui/" + propertyData.button.icon : ""

		Binding on checked {
			value: propertyData && propertyData.value
			when: propertyData != undefined
		}

		onReleased: {
			propertyData.setValue(checked)
		}
	}
}
