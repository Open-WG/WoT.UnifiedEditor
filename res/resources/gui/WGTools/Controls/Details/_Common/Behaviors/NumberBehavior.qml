import QtQuick 2.11
import WGTools.Controls.Details 2.0

Behavior {
	enabled: ControlsSettings.effectEnabled
	NumberAnimation {duration: ControlsSettings.effectDuration}
}
