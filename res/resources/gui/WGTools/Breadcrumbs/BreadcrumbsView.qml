import QtQml.Models 2.11
import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0 as WGT
import WGTools.PropertyGrid 1.0 as WGT

RowLayout {
	id: view

	property alias model: repeater.model
	property ItemSelectionModel selection

	property Component delegate: Breadcrumb {}
	property alias cleanerDelegate: cleanerLoader.sourceComponent

	readonly property alias count: repeater.count

	property real padding: 0
	spacing: ControlsSettings.spacing

	Component.onCompleted: {
		WGT.KeyModifiersMonitor.modifiers
	}

	Loader {
		id: cleanerLoader
		sourceComponent: BreadcrumbsCleaner {}

		Layout.alignment: Qt.AlignTop
		Layout.margins: view.padding
		Layout.rightMargin: 0

		Binding {
			target: cleanerLoader.item
			property: 'enabled'
			value: view.selection && view.selection.hasSelection
		}

		Connections {
			target: cleanerLoader.item
			ignoreUnknownSignals: true
			onClicked: {
				if (view.selection == null)
					return

				let ctrlPressed = Qt.ControlModifier == (view.WGT.KeyModifiersMonitor.modifiers & Qt.ControlModifier)

				if (ctrlPressed) {
					view.selection.clearSelection()
				} else {
					view.selection.clearSelection()
				}
			}
		}
	}
	
	Flow {
		id: flow
		spacing: view.spacing

		Layout.margins: view.padding
		Layout.leftMargin: 0
		Layout.fillWidth: true

		Repeater {
			id: repeater
			delegate: Item {
				id: delegateItem
				implicitWidth: loader.implicitWidth
				implicitHeight: loader.implicitHeight

				readonly property var __index: index
				readonly property var __model: model

				Loader {
					id: loader
					sourceComponent: view.delegate

					readonly property alias index: delegateItem.__index
					readonly property alias model: delegateItem.__model

					WGT.IndexSelectionListener {
						id: itemSelection
						selectionModel: view.selection
						index: view.selection ? view.selection.model.index(loader.index, 0) : null
					}

					Binding {
						target: loader.item
						property: 'checked'
						value: itemSelection.selected
					}

					Connections {
						target: loader.item
						ignoreUnknownSignals: true
						onClicked: {
							if (view.selection == null)
								return

							let ctrlPressed = Qt.ControlModifier == (view.WGT.KeyModifiersMonitor.modifiers)
							if (ctrlPressed) {
								view.selection.select(itemSelection.index, ItemSelectionModel.Toggle)
							} else if (loader.item.checked) {
								view.selection.select(itemSelection.index, ItemSelectionModel.ClearAndSelect)
							} else {
								view.selection.select(itemSelection.index, ItemSelectionModel.Deselect)
								
								if (view.selection.hasSelection) {
									view.selection.select(itemSelection.index, ItemSelectionModel.ClearAndSelect)
								}
							}
						}
					}
				}
			}
		}
	}
}
