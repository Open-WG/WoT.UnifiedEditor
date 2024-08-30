import QtQuick 2.7
import QtQuick.Controls.impl 2.3
import WGTools.Controls.Details 2.0 as Details

IconLabel {
    spacing: control.spacing
    mirrored: control.mirrored
    display: control.display
    alignment: control.display === IconLabel.IconOnly || control.display === IconLabel.TextUnderIcon ? Qt.AlignCenter : Qt.AlignLeft

    icon: control.icon
    text: control.text
    font: control.font
    color: _palette.color1
	opacity: control.enabled ? 1 : 0.5

	leftPadding: ControlsSettings.popupItemLeftPadding - 
		(control.icon.source != "" && control.display === IconLabel.TextBesideIcon ? control.icon.width + control.spacing : 0)
}
