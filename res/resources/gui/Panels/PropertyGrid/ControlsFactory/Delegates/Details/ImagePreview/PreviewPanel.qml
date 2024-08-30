import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import WGT.ImagePreview 1.0 as WGT
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Style 1.0
import "Preview"
import "PreviewGrid"
import "PreviewPlaceholder"
import "PreviewTuner"
import "../Path"

ColumnLayout {
	id: layout
	spacing: ControlsSettings.spacing

	property alias textField: textField
	property alias fileName: imageModel.fileName
	signal previewClicked(int index)
	signal previewDoubleClicked(int index)

	PathTextField {
		id: textField
		valueData: propertyData
		readOnly: !delegateRoot.__enabled
		allowedToBeEmpty: propertyData
			? propertyData.dialog.allowedToBeEmpty || !delegateRoot.__enabled
			: false

		leftPadding: previewPlaceholder.width + spacing
		dialogButton.resourceType: "texture"
		dialogButton.visible: delegateRoot.__enabled

		wrapMode: TextInput.NoWrap
		Layout.fillWidth: true

		echoMode: focus ? TextInput.Normal : TextInput.NoEcho
		implicitHeight: previewPlaceholder.implicitHeight

		onFocusChanged: if (focus) selectAll()

		Text {
			leftPadding: textField.leftPadding
			anchors.bottom: textField.verticalCenter
			width: textField.width - leftPadding
			color: delegateRoot.__enabled ? _palette.color1 : _palette.color3
			elide: Text.ElideMiddle
			visible: !textField.focus
			Style.class: "text-base"
			text: textField.text.split("/").pop()
		}

		Text {
			leftPadding: textField.leftPadding
			font.pixelSize: ControlsSettings.textTinySize
			anchors.top: textField.verticalCenter
			topPadding: ControlsSettings.smallPadding
			width: textField.width - leftPadding
			color: delegateRoot.__enabled ? _palette.color2 : _palette.color3
			elide: Text.ElideMiddle
			visible: !textField.focus
			text: textField.text.split("/").slice(0, -1).join("/")
		}

		Text {
			leftPadding: textField.leftPadding
			font.pixelSize: ControlsSettings.textNormalSize
			font.italic: true
			anchors.verticalCenter: textField.verticalCenter
			width: textField.width - leftPadding
			color: delegateRoot.__enabled ? _palette.color2 : _palette.color3
			visible: textField.text.length == 0
			text: "No file here"
		}

		PreviewTuner {
			id: tuner
			settings: previewSettigns
			channelCount: imageModel.channelCount
		}

		Binding {
			target: textField.background
			property: "color"
			value: _palette.color5
			when: !textField.activeFocus && delegateRoot.__enabled
		}

		Binding {
			target: textField.background.border
			property: "color"
			value: _palette.color14
			when: imageModel.status == WGT.SimpleImageModel.Error && !textField.activeFocus
		}

		Item {
			width: previewPlaceholder.width
			height: previewPlaceholder.height

			PreviewPlaceholder {
				id: previewPlaceholder
				status: imageModel.status
				visible: imageModel.status != WGT.SimpleImageModel.Ready
				Accessible.name: "Placeholder"
			}

			Column {
				id: preview
				visible: !previewPlaceholder.visible
				Accessible.name: "Preview"

				Repeater {
					model: imageModel
			
					delegate: Preview {
						source: model.source
						implicitWidth: previewPlaceholder.implicitWidth
						implicitHeight: previewPlaceholder.implicitHeight
						atlasData: model.atlasData
						atlasType: model.atlasType
						showSingle: true
						settings: previewSettigns
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: waitDoubleClickTimer.restart()
				onDoubleClicked: {
					waitDoubleClickTimer.stop();
					previewDoubleClicked(0);
				}

				Timer {
					id: waitDoubleClickTimer
					interval: Math.min(Qt.styleHints.mouseDoubleClickInterval, 200)
					onTriggered: previewClicked(0)
				}
			}

			layer.enabled: true
			layer.effect: OpacityMask {
				maskSource: Item {
					width: previewPlaceholder.width
					height: previewPlaceholder.height
					anchors.margins: ControlsSettings.strokeWidth

					Rectangle {
						anchors.fill: parent
						anchors.margins: ControlsSettings.strokeWidth
						radius: ControlsSettings.radius - 1

						Rectangle {
							x: width
							width: parent.width / 2
							height: parent.height
						}
					}
				}
			}
		}

		MouseArea {
			id: previewArea
			anchors.fill: parent
			acceptedButtons: Qt.RightButton
			hoverEnabled: true
			property bool hovered: false
			onPressed: {
				tuner.popupEx()
				hovered = false
			}

			ToolTip.text: imageModel.statusText
			ToolTip.delay: ControlsSettings.tooltipDelay
			ToolTip.timeout: ControlsSettings.tooltipTimeout
			ToolTip.visible: ToolTip.text && hovered

			onPositionChanged: hovered = containsMouse
			onExited: hovered = false
		}
	}

	WGT.SimpleImageModel {
		id: imageModel
		fileName: grid.fileName
		useAlpha: previewSettigns.alpha
	}

	PreviewSettings {
		id: previewSettigns
	}

	PreviewGrid {
		id: grid
		model: imageModel
		settings: previewSettigns
		visible: imageModel.status == WGT.SimpleImageModel.Ready && previewArea.hovered
		Accessible.name: "PreviewGrid"
		onVisibleChanged: if (visible) updatePosition(layout)

		onClicked: {
			previewClicked(index)
		}

		onDoubleClicked: {
			previewDoubleClicked(index)
		}
	}

	function reset() {
		previewSettigns.reset()
	}
}
