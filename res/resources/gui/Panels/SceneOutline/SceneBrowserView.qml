import QtQuick 2.7
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls2
import WGTools.ControlsEx 1.0
import QtQuick.Layouts 1.11
import WGTools.Models 1.0
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

	ColumnLayout {
		anchors.fill: parent
		spacing: 0

		// custom header
		Loader {
			id: header
			
			readonly property alias viewContext: root.sceneBrowserContext
			readonly property QtObject panelContext: sceneBrowserContext.headerPanel
				? sceneBrowserContext.headerPanel.context
				: null
			
			sourceComponent: sceneBrowserContext.headerPanel
				? sceneBrowserContext.headerPanel.component
				: undefined

			Layout.fillWidth: true
			Layout.leftMargin: Settings.defaultMargin
			Layout.rightMargin: Settings.defaultMargin
		}

		RowLayout {
			Layout.fillWidth: true
			Layout.leftMargin: Settings.defaultMargin
			Layout.rightMargin: Settings.defaultMargin

			// seach field
			// works with TokenFilterProxyModel (model.filterTokens)
			// and with FilterProxyModel with predicates (model.predicate.text)
			SearchField {

				id: filter
				Layout.fillWidth: true
				Layout.rightMargin: Settings.defaultMargin
				Layout.bottomMargin: Settings.defaultMargin

				property var model: root.sceneBrowserContext.model
				readonly property bool isPredicateProxy: sceneBrowserContext.filterPredicate != null
				visible: isPredicateProxy || model.filterTokens != undefined

				function filterText() {
					if (!visible) return ""
					return isPredicateProxy
						? sceneBrowserContext.filterPredicate.text
						: model.filterTokens
				}

				function setFilterText(text) {
					if (isPredicateProxy) {
						sceneBrowserContext.filterPredicate.text = text
					} else {
						model.filterTokens = text
					}
				}

				placeholderText: "Filter"
				
				text: filterText()
				onTriggered: setFilterText(text)
			}

			// group by
			Controls2.ComboBox {
				id: comboBox
				model: active
					? sceneBrowserContext.selectableData.labels
					: null
				Accessible.name: "Grouping"

				property bool active: sceneBrowserContext.selectableData != undefined

				visible: active
				Layout.leftMargin: Settings.defaultMargin
				Layout.bottomMargin: Settings.defaultMargin

				currentIndex: active
					? sceneBrowserContext.selectableData.currentIndex
					: -1

				onCurrentIndexChanged: {
					if (active) {
						sceneBrowserContext.selectableData.currentIndex = currentIndex
					}
				}
			}
		}

		// scene
		SceneOutlineView {
			id: sceneOutlineView
			sceneOutlineContext: sceneBrowserContext
			model: sceneBrowserContext.model
			selection: sceneBrowserContext.selectionModel
			selectionMode: SelectionMode.ExtendedSelection
			focus: true

			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.leftMargin: Settings.defaultMargin
			Layout.rightMargin: Settings.defaultMargin

			// failed search label
			Controls2.Label {
				anchors.verticalCenter: parent.verticalCenter
				width: parent.width
				horizontalAlignment: Text.AlignHCenter
				wrapMode: Text.Wrap
				
				text: "Your search \"" + filter.text + "\" - nothing found"
				visible: sceneOutlineView.model &&
					itemsCounter.value == 0 &&
					filter.text

				ModelElementsCounter {
					id: itemsCounter
					model: sceneOutlineView.model
					mode: ModelElementsCounter.RootChildren
				}
			}
		}

		// custom footer
		Loader {
			id: footer
			
			readonly property alias viewContext: root.sceneBrowserContext
			readonly property QtObject panelContext: sceneBrowserContext.footerPanel
				? sceneBrowserContext.footerPanel.context
				: null
			
			sourceComponent: sceneBrowserContext.footerPanel
				? sceneBrowserContext.footerPanel.component
				: undefined

			Layout.fillWidth: true
			Layout.leftMargin: Settings.defaultMargin
			Layout.rightMargin: Settings.defaultMargin
		}
	}
}
