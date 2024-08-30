import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0
import WGTools.PropertyGrid 1.0
import "Settings.js" as Settings

PropertyDelegate {
	id: delegateRoot

	property var model // TODO: consider implement context property "model"
	readonly property real padding: Settings.normalVPadding

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight + (padding * 2)
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	RowLayout {
		id: layout
		anchors.fill: parent
		anchors.margins: parent.padding
		spacing: Settings.normalSpacing

		Repeater {
			id: repeater
			model: delegateRoot.propertyData ? delegateRoot.propertyData.options : null

			readonly property int currentIndex: model ? model.indexOf(delegateRoot.propertyData.value) : -1

			Button {
				text: model.display
				checkable: true
				implicitWidth: 1
				Layout.fillWidth: true // grid layouting rule

				onToggled: {
					delegateRoot.propertyData.setValue(model.value)
				}

				Binding on checked {
					value: repeater.currentIndex == index
				}
			}
		}
	}
}
