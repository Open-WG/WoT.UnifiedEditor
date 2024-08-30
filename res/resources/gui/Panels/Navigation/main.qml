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
import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0 as View

Rectangle
{
	property var title: "Navigation"
	property var layoutHint: "bottom"
	Accessible.name: title

	color: _palette.color8
	implicitWidth: 900
	implicitHeight: 570


	SplitView {
		id: papaRow
		anchors.fill: parent

		ColumnLayout{
			Layout.margins: 5
			spacing: 10
			Layout.preferredWidth: papaRow.width * (1/3)
			Layout.fillHeight: true
			
			Controls.Button {
				Layout.fillWidth: true
				text: "Add Point"
				icon.source : "image://gui/add"
				onClicked: context.managerController.addPoint()
			}
			Controls.Button {
				Layout.fillWidth: true
				text: "Make screenshots"
				icon.source : "image://gui/navigation-point"
				onClicked: context.managerController.makeScreenshots()
			}

			SceneOutline.SceneBrowserView {
				Layout.fillHeight: true
				Layout.fillWidth: true
				sceneBrowserContext: context.sceneBrowserData
			}
			
		}

		View.PropertyGrid {
			id: propertyGridView
			Layout.preferredWidth: papaRow.width * (2/3)
			Layout.fillHeight: true

			model: PropertyGridModel {
				id: pgModel
				source: context.managerController.settingsObject
			}

			selection: ItemSelectionModel {
				model: pgModel
			}

		}
	}
}
