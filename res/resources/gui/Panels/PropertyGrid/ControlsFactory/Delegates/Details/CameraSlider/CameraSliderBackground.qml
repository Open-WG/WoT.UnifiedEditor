import QtQuick 2.7
import WGTools.Misc 1.0 as Misc
import "../../Settings.js" as Settings

// TODO: use Column instead of Item. workaround - WOTD-133405
Item {
	id: root
	
	implicitWidth: Math.max(icons.implicitWidth, groove.implicitWidth, valueText.implicitWidth)
	implicitHeight: icons.implicitHeight + groove.implicitHeight + valueText.implicitHeight

	function calcIndicatorPos(indicator, offset) {
		if (offset == undefined)
			offset = 0

		return Math.round(
			Math.max(
				0,
				Math.min(
					width - indicator.width,
					width * (control.visualPosition) - indicator.width/2 + offset)))
	}

	Item {
		id: icons
		width: parent.width
		implicitHeight: Math.max(cameraIndicator.implicitHeight, cameraHomeIndicator.implicitHeight)

		Image {
			id: cameraIndicator
			x: calcIndicatorPos(cameraIndicator, -2)
			source: "image://gui/icon-camera?color=" + encodeURIComponent(valueText.color)

			anchors.bottom: parent.bottom
		}
		
		Image {
			id: cameraHomeIndicator
			source: "image://gui/icon-camera-home?color=" + encodeURIComponent(valueText.color)

			states: State {
				name: "invisible"
				when: cameraIndicator.x < cameraHomeIndicator.width

				PropertyChanges {
					target: cameraHomeIndicator
					opacity: 0
				}
			}

			transitions: Transition {
				NumberAnimation { property: "opacity"; duration: Settings.interactionAnimDuration; easing.type: Easing.OutCubic }
			}

			anchors.bottom: parent.bottom
		}
	}

	CameraSliderGroove {
		id: groove
		width: parent.width

		anchors.top: icons.bottom

		Rectangle {
			id: tick
			x: calcIndicatorPos(tick)
			width: 1
			height: groove.height
			color: valueText.color
			opacity: 0.7
		}
	}

	Misc.Text {
		id: valueText
		x: calcIndicatorPos(valueText)
		text: control.value.toFixed(control.decimals) + (control.units.length ? " " + control.units : "")

		anchors.top: groove.bottom
	}
}
