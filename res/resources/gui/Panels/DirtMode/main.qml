import QtQuick 2.11
import QtQml.Models 2.11
import WGTools.ControlsEx 1.0 as ControlsEx
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Views.Details 1.0 as Views

ControlsEx.Panel {
	id: dlg
	
	title: "Dirt"
	layoutHint: "right"
	property var margins: 10

	View.PropertyGrid {
		id: propertyGrid
		width: parent.width
		height: parent.height

		model: PropertyGridModel {
			id: pgModel
			source: context.dynamicDirt
		}

		selection: ItemSelectionModel {
			model: pgModel
		}
	}
}
