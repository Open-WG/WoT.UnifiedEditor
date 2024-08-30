import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Item {
	id: root

	property alias icon: icon
	property alias label: label
	property alias iconNest: iconNest

	property bool mirrorLayout: false
	property real spacing: 0
	property var verticalAlignment: Qt.AlignVCenter

	implicitWidth: icon.implicitWidth + label.implicitWidth + root.spacing
	implicitHeight: Math.max(icon.implicitHeight, label.implicitHeight)
	baselineOffset: label.y + label.baselineOffset

	Item {
		id: iconNest
		implicitWidth: icon.width
		implicitHeight: icon.height
		clip: true

		anchors {
			top:			root.verticalAlignment == Qt.AlignTop		? root.top				: undefined;
			verticalCenter:	root.verticalAlignment == Qt.AlignVCenter	? root.verticalCenter	: undefined;
			bottom:			root.verticalAlignment == Qt.AlignBottom	? root.bottom			: undefined;
			left:			root.mirrorLayout ? undefined : root.left;
			right:			root.mirrorLayout ? root.right : undefined
		}

		Image {
			id: icon
			fillMode: Image.PreserveAspectFit

			sourceSize.width: width
			sourceSize.height: height

			anchors.centerIn: parent
		}
	}

	Misc.Text {
		id: label
		color: _palette.color2
		elide: Text.ElideRight

		anchors {
			top:			root.verticalAlignment == Qt.AlignTop		? root.top				: undefined;
			verticalCenter: root.verticalAlignment == Qt.AlignVCenter	? root.verticalCenter	: undefined;
			bottom:			root.verticalAlignment == Qt.AlignBottom	? root.bottom			: undefined;
			left:			root.mirrorLayout ? root.left : iconNest.right;
			right:			root.mirrorLayout ? iconNest.left : root.right;
			leftMargin:		root.mirrorLayout ? 0 : root.spacing;
			rightMargin:	root.mirrorLayout ? root.spacing : 0
		}
	}
}
