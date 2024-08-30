import QtQuick 2.10
import QtQml.Models 2.2
import WGTools.AtlasEditor 1.0
import WGTools.ControlsEx 1.0 as ControlsEx

ControlsEx.Panel {
	id: root

	Accessible.name: "Atlas Editor"
	layoutHint: "center"

	implicitWidth: 1000
	implicitHeight: 1000
	
	anchors.fill: parent

	color: "black"

	MouseArea {
		acceptedButtons: Qt.LeftButton
		onClicked: context.selectionModel.clear()
		anchors.fill: parent
	}

	QtAtlasModel {
		id: dataModel
		source: context.object
		selection: context.selectionModel
	}

	Atlas {
		model: dataModel
		viewSettings: context.settings
		selection: context.selectionModel
		width: Math.min(root.width, root.height)
		height: Math.min(root.width, root.height)
		showNumbers: context.settings.showNumbers

		atlasWidth: dataModel.atlasWidth
		atlasHeight: dataModel.atlasHeight
		rowCount: dataModel.rowCount
		columnCount: dataModel.columnCount

		anchors.centerIn: parent
	}
}
