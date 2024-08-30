import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.PropertyGrid 1.0
import "Details/Path" as Details
import "Details/DropDown" as Details
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.ControlsEx 1.0
import "Settings.js" as Settings

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"
	property var propertyRow

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	Details.DropDown {
		id: control
		width: parent.width
		height: parent.height
		popup.contentItem: Details.PathDropDownPopupContent {}
	}

	CustomDropArea {
		parent: delegateRoot.propertyRow
		enabled: delegateRoot.enabled
		target: control
		propertyData: delegateRoot.propertyData
	}
}
