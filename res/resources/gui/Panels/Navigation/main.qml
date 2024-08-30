import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQml.Models 2.2
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.DialogsQml 1.0 as Dialogs
import WGTools.Views.Details 1.0 as Views
import WGTools.ControlsEx 1.0
import "../../Panels/SceneOutline" as SceneOutline

Rectangle
{
	property var title: "Navigation"
	property var layoutHint: "bottom"
	Accessible.name: title

	color: _palette.color8
	implicitWidth: 900
	implicitHeight: 570


	ColumnLayout {
		anchors.fill: parent

		Column{
			Layout.margins: 5
			spacing: 10
			height: controlButtons.implicitHeight
			Layout.fillWidth: true

			RowLayout {
				id: controlButtons
				spacing: 10
				width: parent.width
				Controls.Button {
					Layout.fillWidth: true
					text: "Add Point"
					icon.source : "image://gui/add"
					onClicked: context.managerController.addPoint()
				}
				Controls.Button {
					Layout.fillWidth: true
					text: "Settings"
					icon.source : "image://gui/menu"
					onClicked: context.managerController.settings()
				}
				Controls.Button {
					Layout.fillWidth: true
					text: "Make screenshots"
					icon.source : "image://gui/navigation-point"
					onClicked: context.managerController.makeScreenshots()
				}
			}


			SearchField {
				id: filterTextField
				width: parent.width
				placeholderText: "Filter"
				text: context.sceneBrowserData.model.filterTokens

				onTriggered: context.sceneBrowserData.model.filterTokens = text
			}
		}

		SceneOutline.SceneBrowserView {
			Layout.fillHeight: true
			Layout.fillWidth: true
			sceneBrowserContext: context.sceneBrowserData
		}
	}
}
