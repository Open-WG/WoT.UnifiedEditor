import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Templates 2.3 as T
import WGTools.Controls.Details 2.0 as Details

T.ScrollIndicator {
	id: control

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		contentItem.implicitHeight + topPadding + bottomPadding)

	padding: 2

	contentItem: Details.ScrollIndicatorContent {}
}
