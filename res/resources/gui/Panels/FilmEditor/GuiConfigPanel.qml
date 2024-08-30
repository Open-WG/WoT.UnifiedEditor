import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQml.Models 2.11
import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0 as View
import WGTools.ControlsEx 1.0 as ControlsEx

ControlsEx.Panel {
	property var title: "Filmmaker GUI Configuration"
	property var layoutHint: "left"
	color: _palette.color8

	implicitWidth: 400
	implicitHeight: 400

	PropertyGridModel {
		id: pgModel
		source: context.viewModel
		changesController: context.changesController
	}


	View.PropertyGrid {
		id: propertyGrid

		anchors.fill: parent

		model: pgModel
		visible: !empty
		multiTypeSelection: context.typeCount > 1
	}
}
