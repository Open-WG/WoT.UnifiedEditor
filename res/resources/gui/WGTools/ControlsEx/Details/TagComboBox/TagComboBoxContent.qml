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
					text: model[control.textRole]
					onClose: control.removeTag(model[control.textRole])
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
