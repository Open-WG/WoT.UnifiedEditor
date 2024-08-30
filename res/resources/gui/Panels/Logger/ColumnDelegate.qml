import QtQuick 2.10
import WGTools.Misc 1.0 as Misc
import WGTools.Controls.Details 2.0
import WGTools.Controls 2.0

Item {
	id: item
	property string text: styleData.value
	property string tooltip: ""
	implicitWidth: textItem.implicitWidth

	signal linkActivated(string link)

	Misc.Text {
		id: textItem
		anchors.fill: parent
		visible: text.length != 0
		text: parent.text
		elide: Text.ElideRight

		// for some reason when doing verticalAlignment: Text.AlignVCenter, underline for link is covering text, so align it with padding
		verticalAlignment: Text.AlignBottom
		topPadding: 5
		bottomPadding: 5

		leftPadding: 10
		rightPadding: 10
		onLinkActivated: parent.linkActivated(link)
		linkColor: _palette.color11

		Misc.TextContentArea {
			target: textItem

			ToolTip.delay: ControlsSettings.tooltipDelay
			ToolTip.timeout: ControlsSettings.tooltipTimeout
			ToolTip.visible: ToolTip.text.length != 0 && ma.containsMouse
			ToolTip.text: item.tooltip
		}
	}

	MouseArea {
		id: ma
		anchors.fill: parent
		acceptedButtons: Qt.RightButton
		hoverEnabled: true
		onClicked: menu.popupEx()
	}
}
