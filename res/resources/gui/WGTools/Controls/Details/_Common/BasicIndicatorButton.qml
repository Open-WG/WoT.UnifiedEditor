import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.Button {
	id: control

	property string source

	width: height
	implicitWidth: contentItem.implicitWidth
	implicitHeight: contentItem.implicitHeight
	padding: Math.max(0, (width - implicitWidth) / 2)
	topPadding: Math.max(0, (height - implicitHeight) / 2)
	bottomPadding: topPadding
	focusPolicy: Qt.TabFocus
	visible: opacity

	contentItem: Details.InteractiveImage {src: control.source}

	Details.BackgroundBB {}
	Details.ContentItemBB {}
	Details.IndicatorBB {}
	Details.NumberBehavior on opacity {}
}
