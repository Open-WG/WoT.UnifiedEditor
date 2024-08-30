import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQml.Models 2.2

import Controls 1.0 as SMEControls

import Condition 1.0

import "..//"

ColumnLayout {
	id: root

	property var parameters: null
	property var item: null

	Layout.fillWidth: true

	RowLayout {
		SMEControls.Text {
			text: "Blend Duration (s):"
		}

		FloatSpinBox {
			Layout.fillWidth: true

			Binding on value {
				value: item ? item.duration : 0
			}

			onValueModified: {
				item.duration = value
			}
		}
	}

	ExitTimeCondition {
		Layout.fillWidth: true
		enabled: root.item ? root.item.hasExitTime : false
		exitTimeCondition: root.item ? root.item.exitTimeCondition : null

		onEnabledChanged: root.item.hasExitTime = enabled
	}

	Repeater {
		model: DelegateModel {
			id: conditionDelModel
			model: root.item ? root.item.conditions : null

			RowLayout {
				Layout.maximumHeight: 25
				Layout.fillWidth: true

				SMEControls.ComboBox {
					id: comboConditionName

					Layout.preferredWidth: parent.width / 3

					currentIndex: parameters.mapNameToIndex(itemConditionData.parameterID)

					model: parameters

					Connections {
						target: itemConditionData
						onParameterIDChanged: {
							comboConditionName.model = null
							comboConditionName.model = root.parameters
							comboConditionName.currentIndex 
								= parameters.mapNameToIndex(itemConditionData.parameterID)
						}
					}

					delegate: ItemDelegate {
						id: item

						property bool selected: index == comboConditionName.currentIndex

						width: parent.width
						height: comboConditionName.height

						topPadding: 0
						bottomPadding: 0

						highlighted: comboConditionName.highlightedIndex == index
						hoverEnabled: comboConditionName.hoverEnabled

						text: itemParameterData.name

						icon.source: selected ? "..//Controls//Details//icon-check.png" : ""

						Binding {
							target: comboConditionName
							property: "displayText"
							value: item.text
							when: item.selected
						}

						Binding {
							target: item.contentItem
							property: "color"
							value: "#000000"
						}
					}

					onActivated: {
						itemConditionData.parameterID = displayText
					}
				}

				Loader {
					Layout.fillHeight: true
					Layout.fillWidth: true

					source: {
						if (!root.item)
							return ""

						switch (itemConditionData.type) {
							case Condition.FLOAT_RANGE:
								return "FloatRangeCondition.qml"
							case Condition.BOOL:
								return "BoolCondition.qml"
							case Condition.INT_RANGE:
								return "IntRangeCondition.qml"
							case Condition.TRIGGER:
								return "TriggerCondition.qml"
							case Condition.RANDOM_FLOAT:
								return "RandomFloatCondition.qml"
							default:
								return ""
						}
					}

					property QtObject styleData: QtObject {
						property var condition: root.item ? itemConditionData : null
					}
				}

				SMEControls.Button {
					Layout.preferredHeight: 20

					text: "x"

					onClicked: conditionDelModel.model.removeCondition(
						conditionDelModel.modelIndex(index))
				}
			}
		}
	}
}
