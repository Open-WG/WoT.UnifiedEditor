import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import WGTools.PropertyGrid 1.0
import "Details/SpinBox" as Details
import "Details/Common" as Details
import "Settings.js" as Settings

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight
	propertyData: model ? model.node.property : null

	Details.ControlPositioner {
		target: layout
		data: delegateRoot.model
		fallback.fillHeight: true
		fallback.fillWidth: true
	}

	RowLayout {
		id: layout
		spacing: Settings.normalSpacing
		width: parent.width

		Repeater {
			model: propertyData ? propertyData.valueElements : null

			Details.SpinBox {
				id: control
				spacing: ControlsSettings.spacing
				valueData: modelData
				enabled: !modelData.readonly
				overridden: propertyData && propertyData.overridden

				label.text: propertyData ? propertyData.getElementLabel(index) : ""
				label.color: _palette.color3

				Layout.fillWidth: true
				Layout.preferredWidth: 1
			}
		}
	}
}
