import QtQuick 2.11
import WGTools.Controls.Details 2.0

Behavior {
	enabled: ControlsSettings.effectEnabled && !_palette.themeSwitching
	ColorAnimation {duration: ControlsSettings.effectDuration}
}
