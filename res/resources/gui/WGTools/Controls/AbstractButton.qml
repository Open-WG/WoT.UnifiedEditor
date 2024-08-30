import QtQuick 2.11
import QtQuick.Templates 2.4 as T

T.AbstractButton {
	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		(contentItem ? contentItem.implicitWidth : 0) + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		(contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding)
	
	baselineOffset: contentItem ? contentItem.y + contentItem.baselineOffset : 0
}
