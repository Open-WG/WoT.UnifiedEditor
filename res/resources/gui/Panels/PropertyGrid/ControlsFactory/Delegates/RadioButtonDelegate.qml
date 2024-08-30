import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.PropertyGrid 1.0
import "Details/Common" as Details

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	Details.ControlPositioner {
		target: control
		data: delegateRoot.model
		fallback.horizontalAlignment: LayoutHints.AlignVCenter
	}

	Details.ControlTextProvider {
		id: textProvider
		data: delegateRoot.model
	}

	RadioButton {
		id: control
		text: textProvider.text
		checked: propertyData.value
		onToggled: delegateRoot.propertyData.setValue(checked)
	}
}
