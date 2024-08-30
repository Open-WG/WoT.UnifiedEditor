import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Rectangle {
	id: itemRoot

	property alias imageSource: image.source
	property alias title: titleItem.text
	property alias text: textItem.text

	implicitWidth: column.implicitWidth
	implicitHeight: column.implicitHeight
	color: _palette.color8

	Column {
		id: column

		readonly property real normalMargin: 30

		width: (parent.width > normalMargin * 4) ? (parent.width - normalMargin * 2) : (parent.width / 2)
		height: parent.height
		topPadding: bottomPadding
		bottomPadding: 40
		spacing: 10

		anchors.centerIn: parent

		Image {
			id: image
			width: Math.min(parent.width, implicitWidth)
			height: implicitHeight * width/implicitWidth

			anchors.horizontalCenter: parent.horizontalCenter
		}

		Misc.Text {
			id: titleItem
			width: parent.width
			size: "Large"
			horizontalAlignment: Text.AlignHCenter
			wrapMode: Text.Wrap
		}

		Misc.Text {
			id: textItem
			width: Math.min(250, parent.width)
			horizontalAlignment: Text.AlignHCenter
			wrapMode: Text.Wrap

			anchors.horizontalCenter: parent.horizontalCenter
		}
	}
}
