import QtQuick 2.11
import WGTools.PropertyGrid 1.0
import WGTools.ControlsEx 1.0

PropertyDelegate {
	id: delegateRoot
	property var model

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	TagComboBox {
		id: control
		width: parent.width
		height: parent.height
		sourceModel: propertyData ? propertyData.options : null
		textRole: "display"
		tagString: propertyData && propertyData.value != undefined ? propertyData.value : ""
		Accessible.name: "Tag combo box"

		onTagStringModified: propertyData.setValue(tagString)
	}
}
