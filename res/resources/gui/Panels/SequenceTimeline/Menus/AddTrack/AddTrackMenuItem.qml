import QtQuick 2.11
import WGTools.Controls 2.0

MenuItem {
	id: menuItem

	readonly property url defaultIconSource: "image://gui/animation_sequence/tracks/custom"

	icon.source: defaultIconSource
	Binding on icon.color {
		value: "transparent"
		when: menuItem.icon.source != menuItem.defaultIconSource
	}
}
