import QtQuick 2.11
import WGTools.PropertyGrid 1.0
import "Details/CameraSlider" as Details
import "Details/LodBar" as Details
import "Settings.js" as Settings

LodsDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight
	propertyData: model ? model.node.property : null

	Column {
		id: layout
		width: parent.width
		spacing: Settings.normalSpacing

		Details.LodBar {
			width: parent.width
			model: delegateRoot.lodbarModel
			range: delegateRoot.lodbarRange
			readOnly: delegateRoot.readOnly
		}
	}
}
