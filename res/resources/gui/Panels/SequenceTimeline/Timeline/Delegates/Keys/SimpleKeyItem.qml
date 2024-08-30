import QtQuick 2.11
import QtQml.Models 2.2

import WGTools.AnimSequences 1.0
import WGTools.Clickomatic 1.0 as Clickomatic

import Panels.SequenceTimeline 1.0
import "../Bars"

BaseKeyItem {
	function selectKeys(box, selection) {
		Helpers.selectKeys(box, keyRepeater, styleData.timelineViewID, selection)
	}

	/**************************************************************************
	 * bar
	 */
	Item {
		width: parent.width
		height: Constants.barHeight

		anchors.verticalCenter: parent.verticalCenter

		Repeater {
			model: SimpleKeysBarModel {
				sourceModel: styleData.model
				rootIndex: styleData.modelIndex
			}

			delegate: Loader {
				id: bar

				property real startX
				property real endX

				width: endX - startX
				x: startX

				asynchronous: true
				sourceComponent: SimpleTrackBar {
					color: context.colors.color(model.colorIndex)
				}

				function calcStartX() { return styleData.timelineController.fromSecondsToScale(model.startPosition) }
				function calcEndX() { return styleData.timelineController.fromSecondsToScale(model.endPosition) }

				Binding on startX { value: bar.calcStartX() }
				Binding on endX { value: bar.calcEndX() }

				Connections {
					target: styleData.timelineController
					ignoreUnknownSignals: false
					onScaleChanged: {
						bar.startX = bar.calcStartX()
						bar.endX = bar.calcEndX()
					}
				}
			}
		}
	}

	/**************************************************************************
	 * keys
	 */
	Repeater {
		id: keyRepeater
		model: DelegateModel {
			id: keysModel
			model: styleData.model
			rootIndex: styleData.modelIndex
			delegate: Loader {
				asynchronous: true
				sourceComponent: SimpleKeyDelegate {
					modelIndex: styleData.model ? styleData.model.mapToModel(keysModel.modelIndex(index)) : null
					selectedIndexOffset: keysModel.count
				}

				anchors.verticalCenter: parent.verticalCenter
				anchors.alignWhenCentered: false
			}
		}
	}
}
