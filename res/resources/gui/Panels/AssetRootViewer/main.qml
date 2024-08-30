import QtQuick 2.11

import WGTools.ControlsEx 1.0 as ControlsEx
import "../../Panels/SceneOutline" as SceneOutline


ControlsEx.Panel {
	id: assetRootViewer

	title: "Asset Root Viewer"
	property var layoutHint: "left"
	Accessible.name: title
	property var margins: 10

	SceneOutline.SceneBrowserView {
		anchors.fill: parent
		sceneBrowserContext: context.sceneBrowserData
	}
}
