import QtQuick 2.11
import QtQml.Models 2.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Controls.Details 2.0 as Details

ControlsEx.Panel {
	title: context.title
	layoutHint: "bottom"
	property var margins: 10

	implicitWidth: 800
	implicitHeight: 130
	color: _palette.color8
	Accessible.name: title
	
	View.PropertyGrid {
		anchors.fill: parent

		model: PropertyGridModel {
			id: pgModel
			source: context.object
//			assetSelection: context.assetSelection
			changesController: context.changesController
		}

		selection: ItemSelectionModel {
			model: pgModel
		}
	}
}
