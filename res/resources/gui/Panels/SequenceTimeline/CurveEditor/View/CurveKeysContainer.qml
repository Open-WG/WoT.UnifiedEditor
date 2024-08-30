import QtQuick 2.11
import QtQml.Models 2.2
import Panels.SequenceTimeline 1.0

Item {
	id: root

	property alias model: keyModel.model
	property alias rootIndex: keyModel.rootIndex

	property var curveEditorController: null
	property var trackProxy: null
	property var selectionModel: null
	property var timelineViewID: null
	property var curveViewID: null

	clip: true

	function selectKeys(box, selectionHelper) {
		for (var i = 0; i < keyRepeater.count; ++i)
		{
			var compositeItem = keyRepeater.itemAt(i)
			if (Helpers.selectKeys(box, compositeItem.decomposedRep, root.timelineViewID, selectionHelper))
				selectionHelper.push(compositeItem.modelIndex)
		}
	}

	Repeater {
		id: keyRepeater

		model: DelegateModel {
			id: keyModel

			delegate: Item {
				id: compositeHolder

				property alias decomposedRep: decomposedRepeater
				readonly property var modelIndex: root.model.mapToModel(keyModel.modelIndex(index))

				width: 0
				height: parent.height

				function getPosition() {
					return itemData ? Math.round(context.timelineController.fromSecondsToScale(itemData.position)) : 0
				}

				Binding on x { value: compositeHolder.getPosition() }
				Connections {
					target: context.timelineController
					ignoreUnknownSignals: false
					onScaleChanged: compositeHolder.x = getPosition()
				}

				Repeater {
					id: decomposedRepeater
					
					model: DelegateModel {
						id: componentModel
						model: root.model.model
						rootIndex: root.model.mapToModel(keyModel.modelIndex(index))

						delegate: CurveKey {
							curveEditorController: root.curveEditorController
							selectionModel: root.selectionModel
							modelIndex: index != -1 ? componentModel.modelIndex(index) : null
							model: index != -1 ? root.model.model : null
							combinerHeight: compositeHolder.height
							curveViewID: root.curveViewID
							timelineViewID: root.timelineViewID
							visible: {
								if (index == -1)
									return false

								if (root.trackProxy == null)
									return false

								var element = root.trackProxy.elements[index]
								if (element == null)
									return false

								if (element.disabled)
									return false

								return element.visible
							}

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
