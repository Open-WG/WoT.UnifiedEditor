import QtQuick 2.11
import QtQml.Models 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0 as WGControls
import WGTools.Controls.Details 2.0
import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0 as View

Rectangle{
	property var title: "Terrain texture conversion..."

	implicitHeight: 130
	implicitWidth: 500
	color: _palette.color8

	anchors.fill: parent

	Component.onCompleted: {
		qmlView.minimumHeight = implicitHeight
		qmlView.maximumHeight = implicitHeight
		qmlView.minimumWidth = implicitWidth
	}

	Column {
		id: mainColumn

		anchors.fill: parent
		anchors.margins: ControlsSettings.padding

		property real implicitHeight: ControlsSettings.padding * 2
			+ propertyGridView.implicitHeight
			+ buttonsRow.implicitHeight
			+ spacing

		property real implicitWidth: ControlsSettings.padding * 2
			+ Math.max(propertyGridView.implicitWidth, buttonsRow.implicitWidth)

		spacing: ControlsSettings.spacing

		View.PropertyGrid {
			id: propertyGridView
			width: parent.width
			height: contentItem.childrenRect.height

			model: PropertyGridModel {
				id: pgModel
				source: context.model
			}

			selection: ItemSelectionModel {
				model: pgModel
			}
		}

		RowLayout {
			id: buttonsRow
			spacing: ControlsSettings.spacing
			anchors.left: parent.left
			anchors.right: parent.right

			WGControls.Button {
				Layout.fillWidth: true
				Layout.preferredWidth: cancelButton.implicitWidth
				text: "Ok"
				onClicked: context.accept()
			}

			WGControls.Button {
				id: cancelButton
				Layout.fillWidth: true
				Layout.preferredWidth: implicitWidth
				text: "Cancel"
				onClicked: context.reject()
			}
		}
	}
}
