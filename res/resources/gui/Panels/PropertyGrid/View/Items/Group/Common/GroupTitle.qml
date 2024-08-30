import QtQuick 2.7
import QtQuick.Templates 2.3 as T
import WGTools.Misc 1.0 as Misc
import WGTools.Shapes 1.0 as Shapes
import WGTools.Style 1.0
import "../../../Settings.js" as Settings

T.Button {
	id: control

	property alias expandingAnimationEnabled: rotationBehavior.enabled
	property bool expanded: true;
	property bool overridden: false

	implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
	implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
	baselineOffset: contentItem.y + contentItem.baselineOffset
	spacing: 10
	hoverEnabled: true

	indicator: Shapes.Triangle {
		x: control.leftPadding
		y: control.topPadding + (control.availableHeight - height) / 2
		width: 12
		height: 6
		rotation: expanded ? 0 : -90
		color: control.contentItem.color

		Component.onCompleted: requestPaint() // workaround

		Behavior on rotation {
			id: rotationBehavior
			NumberAnimation { duration: Settings.expandingDuration; easing.type: Easing.OutQuart }
		}
	}

	contentItem: Misc.Text {
		leftPadding: control.indicator.visible ? control.indicator.width + control.spacing : 0
		Style.class: overridden ? "text-bold-overridden" : "text-bold"
		text: (!overridden) ? control.text : "*" + control.text

		verticalAlignment: Text.AlignVCenter
		font.underline: control.visualFocus
		font.capitalization: Font.AllUppercase
		font.letterSpacing: 1
		font.pixelSize: 10

		Behavior on color {
			enabled: !_palette.themeSwitching
			ColorAnimation { duration: 100 }
		}
	}

	background: null
}
