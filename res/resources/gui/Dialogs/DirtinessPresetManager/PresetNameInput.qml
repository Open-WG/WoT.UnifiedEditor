import QtQuick 2.11
import QtQml.Models 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0 as WGControls
import WGTools.Controls.Details 2.0

import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0 as View

Rectangle{
	property var title: "Dirt Preset Name"

	anchors.fill: parent

	implicitWidth: 300
	implicitHeight: 80
	color: _palette.color8

	Accessible.name: title

	Component.onCompleted: {
		qmlView.minimumHeight = implicitHeight
		qmlView.minimumWidth = implicitWidth

		qmlView.postReturnReleased.connect(function(){
			context.accept()
		})
	}

	View.PropertyGrid {
		id: propertyGridView

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: cancelButton.top

		model: PropertyGridModel {
			id: pgModel
			source: context.model
		}

		selection: ItemSelectionModel {
			model: pgModel
		}
	}

	WGControls.Button {
		id: okButton

		anchors.bottom: parent.bottom
		anchors.right: cancelButton.left
		anchors.margins: ControlsSettings.padding

		padding: 3
		width: cancelButton.implicitWidth
		text: "OK"
		onClicked: context.accept()
	}

	WGControls.Button {
		id: cancelButton

		anchors.bottom: parent.bottom
		anchors.right: parent.right
		anchors.margins: ControlsSettings.padding

		padding: 3
		leftPadding: 20
		rightPadding: 20
		text: "Cancel"
		onClicked: context.reject()
	}
}
