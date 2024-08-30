import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQml.Models 2.11
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0 as View
import WGTools.Controls.Details 2.0 as Details

ControlsEx.Panel {
	title: "Dirtiness Preset Manager"
	layoutHint: "bottom"
	Accessible.name: title

	View.PropertyGrid {
		id: propertyGridView
		anchors.fill: parent

		model: PropertyGridModel {
			id: pgModel
			source: context.viewModel
			changesController: context.changesController
		}

		selection: ItemSelectionModel {
			model: pgModel
		}
	}
}
