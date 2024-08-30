import QtQuick 2.11
import WGTools.PropertyGrid 1.0

DropDownDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: loader.item ? loader.item.implicitWidth : 0
	implicitHeight: loader.item ? loader.item.implicitHeight : 0
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	Loader {
		id: loader
		width: parent.width
		height: parent.height

		source: delegateRoot.filterable
			? "Details/DropDown/FilterableDropDown.qml"
			: "Details/DropDown/DropDown.qml"

		property QtObject styleData: QtObject {
			readonly property var clearTextIndex : delegateRoot.clearTextIndex
		}
	}
}
