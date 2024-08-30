import QtQuick 2.7
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls2
import WGTools.ControlsEx 1.0
import WGTools.Misc 1.0
import QtQuick.Layouts 1.11
import WGTools.Models 1.0
import "Settings.js" as Settings
import "Details" as Details

Rectangle {
	id: root
	property var title: "Scene Browser"
	property var layoutHint: "left"
	Accessible.name: "Scene Browser"

	readonly property real minimumWidth: 250

	property var sceneBrowserContext: context
	property alias view: sceneOutlineView

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
			readonly property QtObject panelContext: sceneBrowserContext != undefined && sceneBrowserContext.headerPanel
				? sceneBrowserContext.headerPanel.context
				: null

			sourceComponent: (sceneBrowserContext != null && sceneBrowserContext.headerPanel)
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

				property var model: root.sceneBrowserContext ? root.sceneBrowserContext.model : null
				readonly property bool isPredicateProxy: sceneBrowserContext != undefined && sceneBrowserContext.filterPredicate != null
				readonly property bool selfVisible: isPredicateProxy || (model != null && model.filterTokens != undefined)
				visible: selfVisible

				function filterText() {
					if (!selfVisible) return ""
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
			Details.DropDown {
				id: comboBox
				Accessible.name: "Grouping"

				property bool active: sceneBrowserContext != undefined && sceneBrowserContext.selectableData != undefined

				selectableData: active ? sceneBrowserContext.selectableData : null
				filterData: sceneBrowserContext != undefined ? sceneBrowserContext.filterData : null
				visible: active

				Layout.leftMargin: Settings.defaultMargin
				Layout.bottomMargin: Settings.defaultMargin
			}
		}

		// scene
		SceneOutlineView {
			id: sceneOutlineView
			sceneOutlineContext: sceneBrowserContext
			model: sceneBrowserContext ? sceneBrowserContext.model : null
			selection: sceneBrowserContext ? sceneBrowserContext.selectionModel : null
			selectionMode: SelectionMode.ExtendedSelection
			focus: true

			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.leftMargin: Settings.defaultMargin
			Layout.rightMargin: Settings.defaultMargin

			// failed search label
			FilterResultPlaceholder {
				anchors.verticalCenter: parent.verticalCenter
				width: parent.width
				model: sceneOutlineView.model
				searchText: filter.text
			}
		}

		// custom footer
		Loader {
			id: footer

			readonly property alias viewContext: root.sceneBrowserContext
			readonly property QtObject panelContext: sceneBrowserContext && sceneBrowserContext.footerPanel
				? sceneBrowserContext.footerPanel.context
				: null

			sourceComponent: sceneBrowserContext && sceneBrowserContext.footerPanel
				? sceneBrowserContext.footerPanel.component
				: undefined

			Layout.fillWidth: true
			Layout.leftMargin: Settings.defaultMargin
			Layout.rightMargin: Settings.defaultMargin
		}
	}
}
