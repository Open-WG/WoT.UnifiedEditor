import QtQuick 2.11
import WGTools.Controls.Details 2.0
import WGTools.ControlsEx 1.0
import WGTools.ControlsEx.Details 1.0 as DetailsEx

DetailsEx.FilterableComboBoxContent {
	Flow  {
		id: flow
		width: parent.width
		spacing: ControlsSettings.strokeWidth
		Repeater {
			id: repeater
			model: control.tagModel
			delegate: Item {
				width: tag.width
				height: tag.height + ControlsSettings.smallPadding
				Tag {
					id: tag
					text: model.display
					onClose: control.removeTag(model.display)

					Binding on color {
						when: !model.valid
						value: tag.enabled ? (tag.hovered ? _palette.color7 : _palette.color8) : "transparent"
					}

					Binding on textColor {
						when: !model.valid
						value: tag.enabled ? _palette.color3 : _palette.color5
					}
				}
			}
		}

		onPositioningComplete: parent.updatePadding()
	}

	onContentWidthChanged: updatePadding()

	function updatePadding() {
		if (flow.children.length <= 1) {
			leftPadding = 0
			topPadding = 0
		} else {
			var lastTag = flow.children[flow.children.length - 2]
			leftPadding = ControlsSettings.smallPadding
			if (width - lastTag.x - lastTag.width < contentWidth + leftPadding + rightPadding) {
				topPadding = lastTag.y + lastTag.height
			} else {
				leftPadding += lastTag.x + lastTag.width
				topPadding = lastTag.y
			}
		}
		control.popup.arrange()
	}
}
