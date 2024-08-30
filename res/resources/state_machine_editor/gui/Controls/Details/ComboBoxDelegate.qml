import QtQuick 2.7
import QtQuick.Controls 2.3

ItemDelegate {
	id: item

	property bool selected: index == control.currentIndex

	width: parent.width
	height: control.height

	topPadding: 0
	bottomPadding: 0

	highlighted: control.highlightedIndex == index
	hoverEnabled: control.hoverEnabled

	text: control.textRole
		? Array.isArray(control.model)
			? modelData[control.textRole]
			: model[control.textRole]
		: modelData

	icon.source: selected ? "icon-check.png" : ""

	Binding {
		target: item.contentItem
		property: "color"
		value: "#000000"
	}
}
