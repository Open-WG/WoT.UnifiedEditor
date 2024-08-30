import QtQuick 2.11
import WGTools.PropertyGrid 1.0
import "Details/SpinBox" as Details
import "Details/Common" as Details

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	Details.ControlPositioner {
		target: control; data: model
		fallback.fillHeight: true
	}

	Details.SpinBox {
		id: control
		valueData: propertyData
	}
}
