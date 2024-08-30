import QtQuick 2.10
import "../Preview"
import "../../../Settings.js" as Settings

Column {
	id: root

	width: (root.source.source == "" ? Settings.imagePreviewZoomSizeAtlas : Settings.imagePreviewZoomSizeSingle) / (repeater.count > 1 ? 2 : 1)
	height: title.height + preview.height

	property var source
	property alias title: title
	property alias settings: preview.settings

	signal clicked()
	signal doubleClicked()

	PreviewTitle {
		id: title
		width: preview.width
		visible: text.length
	}

	Preview {
		id: preview
		width: parent.width
		height: width
		source: root.source.source
		atlasData: root.source.atlasData
		atlasType: root.source.atlasType
	}
}
