import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3
import QtQuick.Templates 2.3 as T
import WGTools.Misc 1.0 as Misc
import WGTools.Debug 1.0

T.RadioButton {
    id: control

	property var imagePath: ""

	Accessible.name: imagePath

    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentItem.implicitHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 3
    spacing: 3

	contentItem: Column {

		spacing: control.spacing

		Rectangle {
			implicitWidth: 64
			implicitHeight: 64
			
			radius: 3
			color: control.checked
				? control.palette.text
				: control.down
					? control.palette.light
					: control.palette.base
		
			Image {
				source: imagePath
				height: indicator.height
				width: indicator.width
				anchors.fill: parent
			}
		}
		Misc.Text {
			text: control.text
			width: parent.width
			horizontalAlignment: Text.AlignHCenter
		}
	}
}
