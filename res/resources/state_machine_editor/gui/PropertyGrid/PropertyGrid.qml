import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import Controls 1.0 as SMEControls
import ItemTypes 1.0

import "..//"

//hardcoded property grid
//will be replaced by UE property grid after integration

Flickable {
	id: root

	property alias parameters: transitionEdge.parameters

	property var _selectedIndex: getIndex()
	property var item: _selectedIndex
		? smeContext.graphModel.getItem(_selectedIndex)
		: null
	readonly property bool sleepNodeSelected: item ? item.type == ItemTypes.SLEEP_NODE : false
	readonly property bool sequenceNodeSelected: item ? item.type == ItemTypes.SEQUENCE_NODE : false
	readonly property bool transitionSelected: item ? item.type == ItemTypes.TRANSITION : false
	readonly property bool animationNodeSelected: item ? item.type == ItemTypes.ANIMATION_NODE : false

	interactive: true
	clip: true

	implicitWidth: contentWidth
	implicitHeight: contentHeight

	contentWidth: width
	contentHeight: rootLayout.height

	function getIndex() {
		return smeContext.selectionModel.hasSelection ? smeContext.selectionModel.selectedIndexes[0] : 0
	}

	Connections {
		target: smeContext.selectionModel.model

		onModelReset: _selectedIndex = Qt.binding(getIndex)
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			forceActiveFocus()
		}
	}

	RowLayout {
		id: rootLayout
		width: parent.width

/////////////////////////////////SleepNode Start////////////////////////////////////
		ColumnLayout {
			visible: root.sleepNodeSelected

			SMEControls.Text {
				text: "Label:"
			}

			SMEControls.Text {
				text: "Start:"
			}

			SMEControls.Text {
				text: "End:"
			}
		}

		ColumnLayout {
			visible: root.sleepNodeSelected
			Layout.fillWidth: true

			SMEControls.TextField {
				Binding on text {
					value: root.item && visible ? item.label : ""
				}

				Layout.fillWidth: true
				Layout.maximumHeight: 20

				selectByMouse: true
				padding: 0

				onEditingFinished: {
					if (text == item.label)
						return

					if (smeContext.controller.validateVertexLabel(text)) {
						item.label = text
					}
					else {
						errorToolTip.visible = true
						text = item.label
					}
				}

				ToolTip {
					id: errorToolTip

					text: "Label must be unique"
					timeout: 2000
				}
			}

			FloatSpinBox {
				id: startSpinBox

				Layout.fillWidth: true

				Binding on value {
					value: root.item ? root.item.sleepStart : 0
				}

				onValueModified: {
					root.item.sleepStart = value
				}
			}

			FloatSpinBox {
				id: endSpinBox

				Binding on value {
					value: root.item ? root.item.sleepEnd : 0
				}

				Layout.fillWidth: true

				onValueModified: {
					root.item.sleepEnd = value
				}
			}
		}
/////////////////////////////////SleepNode End////////////////////////////////////
//////////////////////////////SequenceNode Start//////////////////////////////////
		ColumnLayout {
			visible: root.sequenceNodeSelected

			SMEControls.Text {
				text: "Label:"
			}

			SMEControls.Text {
				text: "Resource:"
			}

			SMEControls.Text {
				text: "Loop Count:"
			}

			SMEControls.Text {
				text: "Loop:"
			}
		}

		ColumnLayout {
			id: seqDataColumn

			visible: root.sequenceNodeSelected
			Layout.fillWidth: true

			SMEControls.TextField {
				Binding on text {
					value: root.item && visible ? item.label : ""
				}
				
				hoverEnabled:true

				selectByMouse: true

				Layout.fillWidth: true
				Layout.maximumHeight: 20
				padding: 0

				onEditingFinished: {
					if (text == item.label)
						return

					if (smeContext.controller.validateVertexLabel(text)) {
						item.label = text
					}
					else {
						sequenceErrorToolTip.visible = true
						text = item.label
					}
				}

				ToolTip {
					id: sequenceErrorToolTip

					text: "Label must be unique"
					timeout: 2000
				}
			}

			RowLayout {
				Layout.fillWidth: true

				SMEControls.Text {
					text: root.item && root.item.resource ? root.item.resource : ""
					elide: Text.ElideLeft

					Layout.fillWidth: true
					Layout.maximumHeight: 20
					padding: 0

					MouseArea {
						id: resMA
						anchors.fill: parent
						hoverEnabled: true
					}

					ToolTip {
						visible: resMA.containsMouse && text.length
						text: parent.text
					}
				}

				Button {
					id: resButton
					text: "..."

					Layout.maximumHeight: 15
					Layout.maximumWidth: 30

					onClicked: {
						var file = smeContext.selectSequenceResource()
						if (file.length)
							root.item.resource = file
					}
				}
			}

			FloatSpinBox {
				id: loopCountSeq
				Layout.fillWidth: true

				decimals: 0

				from: -1

				validator: IntValidator {
					bottom: Math.min(loopCountSeq.from, loopCountSeq.to)
				}

				Binding on value {
					value: root.item ? root.item.loopCount : 0
				}

				onValueModified: {
					root.item.loopCount = value
				}
			}

			SMEControls.CheckBox {
				Layout.maximumHeight: 15
				Layout.maximumWidth: 15

				Binding on checked {
					value: root.item ? root.item.loop : false
				}

				onCheckedChanged: {
					if (root.item)
						root.item.loop = checked
				}
			}
		}
//////////////////////////////SequenceNode End//////////////////////////////////
////////////////////////////AnimationNode Start/////////////////////////////////
		ColumnLayout {
			visible: root.animationNodeSelected

			SMEControls.Text {
				text: "Label:"
			}

			SMEControls.Text {
				id: animResLabel
				text: "Resource:"
			}

			SMEControls.Text {
				id: clipLabel
				text: "Clip:"
			}

			SMEControls.Text {
				id: animLoopLabel
				text: "Loop:"
			}
		}

		ColumnLayout {
			id: animDataColumn

			visible: root.animationNodeSelected
			Layout.fillWidth: true

			SMEControls.TextField {
				Binding on text {
					value: root.item && visible ? item.label : ""
				}
				
				hoverEnabled:true

				selectByMouse: true

				Layout.fillWidth: true
				Layout.maximumHeight: 20
				padding: 0

				onEditingFinished: {
					if (text == item.label)
						return

					if (smeContext.controller.validateVertexLabel(text)) {
						item.label = text
					}
					else {
						animErrorToolTip.visible = true
						text = item.label
					}
				}

				ToolTip {
					id: animErrorToolTip

					text: "Label must be unique"
					timeout: 2000
				}
			}

			RowLayout {
				Layout.fillWidth: true

				SMEControls.Text {
					text: root.item && root.item.resource ? root.item.resource : ""
					elide: Text.ElideLeft

					Layout.fillWidth: true
					Layout.maximumHeight: 20
					padding: 0

					MouseArea {
						id: animResMA
						anchors.fill: parent
						hoverEnabled: true
					}

					ToolTip {
						visible: animResMA.containsMouse && text.length
						text: parent.text
					}
				}

				Button {
					id: animResButton
					text: "..."

					Layout.maximumHeight: 15
					Layout.maximumWidth: 30

					onClicked: {
						var file = smeContext.selectFbxResource()
						if (file.length)
							root.item.resource = file
					}
				}
			}

			SMEControls.ComboBox {
				id: clipComboBox

				Layout.fillWidth: true
				Layout.maximumHeight: 15

				Binding on currentIndex {
					value: clipComboBox.getCurrentIndex()
				}

				model: root.item ? root.item.clipNames : null

				onActivated: {
					root.item.clip = displayText
				}

				onModelChanged: currentIndex = getCurrentIndex()

				function getCurrentIndex() {
					if (root.item && root.item.clipNames)
						return root.item.clipNames.indexOf(root.item.clip)
					return -1
				}
			}

			SMEControls.CheckBox {
				Layout.maximumHeight: 15
				Layout.maximumWidth: 15

				Binding on checked {
					value: root.item ? root.item.loop : false
				}

				onCheckedChanged: {
					if (root.item)
						root.item.loop = checked
				}
			}
		}
////////////////////////////AnimationNode End///////////////////////////////////
//////////////////////////////Transition Start//////////////////////////////////
		TransitionEdge {
			id: transitionEdge

			visible: root.transitionSelected

			Layout.fillWidth: true

			item: root.transitionSelected ? root.item : null

			SMEControls.Button {
				id: addTransitionButton
				visible: root.transitionSelected
				enabled: root.parameters.hasParameters
				
				text: "Add Condition"
				Layout.fillWidth: true

				onClicked: {
					root.item.conditions.addNewCondition()
				}
			}
		}
//////////////////////////////Transition End//////////////////////////////////
	}
}
