import QtQuick 2.10
import WGTools.Controls.Details 2.0
import WGTools.Misc 1.0 as Misc
import WGTools.Utils 1.0

Column {
	id: root

	property real breadcrumbsHeight: 18
	property alias model: repeater.model
	property alias text: input.text

	signal tagClicked(string tagName)

	spacing: ControlsSettings.spacing

	Row {
		width: parent.width
		spacing: ControlsSettings.spacing

		SearchIcon {
			opacity: repeater.count ? 0 : 1
			height: root.breadcrumbsHeight
		}

		Flow {
			id: flow
			width: parent.width - x
			spacing: ControlsSettings.spacing

			add: Transition {
				NumberAnimation { property: "opacity"; from: 0.3; to: 1; duration: 200 }
			}

			Repeater {
				id: repeater
				delegate: TagDelegate {
					height: root.breadcrumbsHeight
					onCloseClicked: root.tagClicked(model.tagName)
				}
			}

			Item {
				width: Utils.clamp(input.implicitWidth, 10, flow.width - flow.leftPadding - flow.rightPadding)
				height: input.height

				Misc.TextInput {
					id: input
					width: flow.width - flow.rightPadding - parent.x
					height: (wrapMode == TextInput.NoWrap) ? root.breadcrumbsHeight : undefined;
					wrapMode: width == (flow.width - flow.leftPadding - flow.rightPadding) ? TextInput.Wrap : TextInput.NoWrap
					validator: RegExpValidator { regExp: /[\S]*/ }
					color: _palette.color1
					focus: true
				}
			}
		}
	}

	Rectangle {
		width: parent.width
		height: 2
		color: _palette.color12
	}
}
