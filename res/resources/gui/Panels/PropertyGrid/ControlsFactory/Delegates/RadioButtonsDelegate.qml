import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.PropertyGrid 1.0
import "Settings.js" as Settings

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	Flow {
		id: layout
		width: parent.width
		spacing: Settings.normalSpacing

		Repeater {
			id: repeater
			model: delegateRoot.propertyData ? delegateRoot.propertyData.options : null

			readonly property int currentIndex: model ? model.indexOf(delegateRoot.propertyData.value) : -1

			RadioButton {
				text: model.display
				Accessible.name: text

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
