import QtQuick 2.7
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls2
import "Settings.js" as Settings

Rectangle {
	id: root
	property var title: "Scene Browser"
	property var layoutHint: "left"
	Accessible.name: "Scene Browser"
	
	readonly property real minimumWidth: 250

	property var sceneBrowserContext: context

	implicitWidth: 400
	implicitHeight: 400

	color: _palette.color8

	Loader {
		id: header
		
		readonly property alias viewContext: root.sceneBrowserContext
		readonly property QtObject panelContext: sceneBrowserContext.headerPanel
			? sceneBrowserContext.headerPanel.context
			: null
		
		sourceComponent: sceneBrowserContext.headerPanel
			? sceneBrowserContext.headerPanel.component
			: undefined

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: groupByLoader.left
		anchors.leftMargin: Settings.defaultMargin
		anchors.rightMargin: Settings.defaultMargin
		height: item ? item.implicitHeight : 0
	}

	SceneOutlineView {
		id: sceneOutlineView
		sceneOutlineContext: sceneBrowserContext
		model: sceneBrowserContext.model
		selection: sceneBrowserContext.selectionModel
		selectionMode: SelectionMode.ExtendedSelection
		focus: true

		anchors.top: header.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: footer.top
		anchors.topMargin: Settings.defaultMargin
		anchors.bottomMargin: Settings.defaultMargin
	}

	Loader {
		id: footer
		
		readonly property alias viewContext: root.sceneBrowserContext
		readonly property QtObject panelContext: sceneBrowserContext.footerPanel
			? sceneBrowserContext.footerPanel.context
			: null
		
		sourceComponent: sceneBrowserContext.footerPanel
			? sceneBrowserContext.footerPanel.component
			: undefined

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.margins: Settings.defaultMargin
		height: item ? item.implicitHeight : 0
	}

	// group by
	Component {
		id: groupByComponent

		Controls2.ComboBox {
			id: comboBox
			model: sceneBrowserContext.grouper.labels
			Accessible.name: "Grouping"

			onActivated: {
				if (currentIndex != -1) {
					sceneBrowserContext.grouper.groupBy = currentText
				}
			}

			Connections {
				target: sceneBrowserContext.grouper
				onGroupByChanged: updateCurrentIndex()
			}

			Component.onCompleted: {
				updateCurrentIndex()
			}

			function updateCurrentIndex() {
				var id = comboBox.find(sceneBrowserContext.grouper.groupBy)
					if (id != -1) {
						currentIndex = id
					}
			}
		}
	}

	Loader {
		id: groupByLoader

		sourceComponent: (sceneBrowserContext.grouper != undefined && sceneBrowserContext.grouper != null)
		 	? groupByComponent
		 	: undefined

		anchors.bottom: header.bottom
		anchors.right: parent.right
		anchors.margins: 4
		height: 23
		width: item ? 110 : 0
	}
}
