import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

Rectangle {
	id: handle
	implicitWidth: ControlsSettings.scrollbarWidth
	implicitHeight: implicitWidth
	opacity: ControlsSettings.scrollbarOpacity
	visible: control.size < 1.0
	color: control.pressed ? _palette.color8 : _palette.color2

	states: State {
		name: "active"
		when: control.policy === T.ScrollBar.AlwaysOn || (control.active && control.size < 1.0)
		
		PropertyChanges {
			target: handle
			opacity: ControlsSettings.scrollbarActiveOpacity
		}
	}

	transitions: Transition {
		from: "active"

		SequentialAnimation {
			PauseAnimation { duration: ControlsSettings.scrollbarDelay }
			NumberAnimation {
				target: handle
				property: "opacity"
				to: ControlsSettings.scrollbarOpacity
				duration: ControlsSettings.effectDuration
			}
		}
	}

	Details.NumberBehavior on implicitWidth {}
	Details.NumberBehavior on implicitHeight {}
	Details.ColorBehavior on color {}
}
