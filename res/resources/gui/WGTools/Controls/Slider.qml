import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details

T.Slider {
	id: control

	property alias ticks: ticks
	property alias labels: labels
	property var minSoft: from
	property var maxSoft: to

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		Math.max(
			handle ? handle.implicitWidth : 0,
			contentItem ? contentItem.implicitWidth : 0) + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(
			handle ? handle.implicitHeight : 0,
			contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding)
	
	spacing: 0
	padding: 0

	handle: Details.SliderHandle {}
	contentItem: Details.SliderContent {}
	background: Details.SliderBackground {}

	Details.SliderToolTip {source: control}
	Details.SliderScaleData {id: ticks}
	Details.SliderLabelsData {id: labels}

	Details.BackgroundBB {}
	Details.ContentItemBB {}
	Details.IndicatorBB {a:handle}
}
