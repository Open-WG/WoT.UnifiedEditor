import QtQuick 2.11
import WGTools.PropertyGrid 1.0
import "Details/CheckBox" as Details
import "Details/Common" as Details

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null;
	enabled: propertyData && !propertyData.readonly

	Details.ControlPositioner {
		id: positioner
		target: control
		data: delegateRoot.model
		fallback.verticalAlignment: LayoutHints.AlignVCenter
	}

	Details.ControlTextProvider {
		id: textProvider
		data: delegateRoot.model
	}
	
	Details.CheckBox {
		id: control
		text: textProvider.text
		valueData: propertyData
		tooltip: textProvider.tooltip

		LayoutMirroring.enabled: positioner.layoutHints.mirroring
	}
}
