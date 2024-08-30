import QtQuick 2.10
import WGTools.ControlsEx 1.0 as ControlsEx

Item {
	id: root

	property var source
	property var atlasData
	property var atlasType

	property PreviewSettings settings
	property alias showAtlasNumbers: img.showAtlasNumbers
	property alias showEmptySlotIcons: img.showEmptySlotIcons
	property alias showSingle: img.showSingle

	PreviewBackground {
		id: background

		checkerboard.width: img.width
		checkerboard.height: img.height

		anchors.fill: parent

		Binding on color { value: root.settings.backgroundColor; when: root.settings }
		Binding { target: background.checkerboard; property: "visible"; value: root.settings.checkerboard; when: root.settings }
	}

	PreviewLoader {
		id: img
		anchors.fill: parent
		source: root.source
		atlasData: root.atlasData
		atlasType: root.atlasType
		settings: root.settings
	}
}
