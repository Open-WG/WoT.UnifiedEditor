import QtQuick 2.7
import WGTools.Misc 1.0 as Misc
import WGTools.Utils 1.0

Item {
	id: root

	property real minTextWidth: 0
	property real maxTextWidth: 150

	property real spacing: 5
	property real rightPadding: 5

	property alias text: label.text
	property alias iconColor: icon.color

	implicitWidth: icon.implicitWidth + spacing + flickable.implicitWidth + rightPadding
	implicitHeight: Math.max(icon.implicitHeight, flickable.implicitHeight)

	TagIcon {
		id: icon
		width: height
		height: parent.height
		text: label.text
	}

	Flickable {
		id: flickable
		width: parent.width - x - root.rightPadding
		implicitWidth: Utils.clamp(contentWidth, root.minTextWidth, root.maxTextWidth)
		implicitHeight: contentHeight
		contentWidth: label.contentWidth
		contentHeight: label.contentHeight
		boundsBehavior: Flickable.StopAtBounds
		interactive: contentWidth > width
		clip: true

		anchors.left: icon.right
		anchors.leftMargin: root.spacing
		anchors.verticalCenter: parent.verticalCenter
		anchors.verticalCenterOffset: 1

		Misc.Text {
			id: label
			enabled: false
			size: "Small"
			font.bold: true
		}
	}
}
