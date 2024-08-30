import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQml.Models 2.2
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.DialogsQml 1.0 as Dialogs
import WGTools.Debug 1.0
import WGTools.Views.Details 1.0 as Views
import "../../Panels/SceneOutline" as SceneOutline

Rectangle {
	id: floraImportDlg
	property var title: "Flora Import"
	Accessible.name: title

	color: _palette.color7
	implicitWidth: 900
	implicitHeight: 570

	ColumnLayout {
		anchors.fill: parent

		SplitView {
			id: floraSplitView
			Layout.fillHeight: true
			Layout.fillWidth: true
			orientation: Qt.Horizontal

			SceneOutline.SceneBrowserView {
				id: floraSceneItemView
				sceneBrowserContext: context.floraSceneItemData
			}

			SceneOutline.SceneBrowserView {
				id: allSpacesFloraSceneItemView
				sceneBrowserContext: context.importFloraAssetSceneItemData
			}
		}
	}
}
