import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.PropertyGrid 1.0
import "Details/Slider" as Details
import "Details/SpinBox" as Details
import "Settings.js" as Settings

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	RowLayout {
		id: layout
		spacing: Settings.normalSpacing
		anchors.fill: parent

		Details.SpinBox {
			id: spinbox
			valueData: propertyData

			Layout.alignment: Qt.AlignTop
			Layout.fillWidth: !slider.visible
			Layout.maximumWidth: implicitWidth

			Accessible.name: "Value"
		}

		Details.Slider {
			id: slider
			valueData: propertyData
			visible: (layout.width - spinbox.implicitWidth - layout.spacing) > (handle.width + leftPadding + rightPadding)

			Accessible.name: "Slider"

			Layout.fillWidth: true
			Layout.minimumWidth: 15 // TODO: fix
			Layout.alignment: Qt.AlignVCenter
		}
	}
}
