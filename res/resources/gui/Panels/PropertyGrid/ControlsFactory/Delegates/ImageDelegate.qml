import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0
import WGTools.PropertyGrid 1.0

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitHeight: img.height
	implicitWidth: img.width
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readOnly
	
	Connections {
		target: propertyData
		onValueChanged: {
			var oldSource = img.source
			img.source = ""
			img.source = oldSource
		}
	}

	Image {
		id: img
		cache: false
		anchors.horizontalCenter: parent.horizontalCenter
		source: propertyData.value
	}
}
