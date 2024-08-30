import QtQuick 2.11
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
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

	Button {
		id: control
		flat: text == "" && icon.source != ""
		text: propertyData ? propertyData.button.text : ""
		icon.source: (propertyData && propertyData.button.icon) ? "image://gui/" + propertyData.button.icon : ""
		onClicked: propertyData.button.invoke()

		ToolTip.text: propertyData ? propertyData.button.tooltip : ""
		ToolTip.delay: ControlsSettings.tooltipDelay
		ToolTip.timeout: ControlsSettings.tooltipTimeout
		ToolTip.visible: ToolTip.text && hovered

		Accessible.name: text || "Button"
	}
}
