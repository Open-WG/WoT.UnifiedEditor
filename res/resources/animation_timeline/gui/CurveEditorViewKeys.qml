import QtQuick 2.7
import QtQml.Models 2.2

import "Helpers.js" as Helpers
import "Debug"
import "Constants.js" as Constants

Item {
	id: root

	property alias model: keyModel.model
	property alias rootIndex: keyModel.rootIndex

	property var context: null
	property var curveEditorController: null
	property var trackProxy: null
	property var selectionModel: null
	property var timelineViewID: null
	property var curveViewID: null
	property var keyDeleteSignalHolder: null

	function selectKeys(selModel, box, selectionHelper) {
		for (var i = 0; i < keyRepeater.count; ++i)
		{
			var compositeItem = keyRepeater.itemAt(i)
			if (Helpers.selectKeys(selModel, box, compositeItem.decomposedRep, root.timelineViewID,
				selectionHelper))
				selectionHelper.push(compositeItem.modelIndex)
		}
	}

	Repeater {
		id: keyRepeater

		model: DelegateModel {
			id: keyModel

			delegate: Item {
				id: compositeHolder

				property var itemModel: model
				property alias decomposedRep: decomposedRepeater

				readonly property var modelIndex: root.model.mapToModel(keyModel.modelIndex(index))

				x: getKeyPosition()

				anchors.bottom: root.bottom

				width: 1
				height: root.height

				function getKeyPosition() {
					return Math.round(context.timelineController.fromSecondstoScale(
								model.itemKeyPosition))
				}

				Connections {
					target: context.timelineController
					ignoreUnknownSignals: false
					onScaleChanged: {
						compositeHolder.x = Qt.binding(getKeyPosition)
					}
				}

				Repeater {
					id: decomposedRepeater

					model: DelegateModel {
						id: componentModel
						model: root.model.model
						rootIndex: root.model.mapToModel(keyModel.modelIndex(index))

						delegate: CurveKeyDelegate {
							visible: trackProxy ? trackProxy.elements[index].visible : false

							curveEditorController: root.curveEditorController
							selectionModel: root.selectionModel
							context: root.context
							keyDeleteSignalHolder: root.keyDeleteSignalHolder
							modelIndex: componentModel.modelIndex(index)
							combinerHeight: compositeHolder.height
							curveViewID: root.curveViewID
							timelineViewID: root.timelineViewID

							onSelectionChanged: {
								var isParentSelected = selectionModel.isSelected(compositeHolder.modelIndex)

								var childSelected = false
								for (var i = 0; i < decomposedRepeater.count; ++i) {
									if (selectionModel.isSelected(componentModel.modelIndex(i))) {
										childSelected = true
										break
									}
								}

								if (childSelected && !isParentSelected)
									selectionModel.select(compositeHolder.modelIndex, ItemSelectionModel.Select)
								else if (!childSelected && isParentSelected)
									selectionModel.select(compositeHolder.modelIndex, ItemSelectionModel.Deselect)
							}
						}
					}
				}
			}
		}
	}
}
