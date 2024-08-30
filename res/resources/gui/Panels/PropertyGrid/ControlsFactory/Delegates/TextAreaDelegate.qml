import QtQuick 2.11
import WGTools.PropertyGrid 1.0
import "Details/TextArea" as Details

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: true

	Details.TextArea {
		id: control
		width: parent.width
		height: parent.height
		valueData: propertyData
	}
}
