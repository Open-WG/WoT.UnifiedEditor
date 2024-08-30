import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.PropertyGrid 1.0
import "Details/Path" as Details
import "Settings.js" as Settings

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null

	Details.PathTextField {
		id: control
		width: parent.width
		height: parent.height
		valueData: propertyData

		// can change existing folder only with open button dialog
		readOnly: propertyData && (propertyData.readonly || (propertyData.dialog.selectExisting && propertyData.dialog.selectFolder))
		pathButtonReadOnly: propertyData && propertyData.readonly
		allowedToBeEmpty: propertyData
			? propertyData.dialog.allowedToBeEmpty  || propertyData.readonly
			: false
		overridden: propertyData && propertyData.overridden
	}
}
