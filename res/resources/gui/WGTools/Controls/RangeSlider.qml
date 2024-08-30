import QtQuick 2.11
import WGTools.Templates 1.0 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.Debug 1.0

T.RangeSlider {
	id: control

	property alias ticks: ticks
	property alias labels: labels
	property alias firstToolTip: firstToolTip
	property alias secondToolTip: secondToolTip

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		Math.max(
			first.handle ? first.handle.implicitWidth : 0,
			second.handle ? second.handle.implicitWidth : 0,
			contentItem ? contentItem.implicitWidth : 0) + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(
			first.handle ? first.handle.implicitHeight : 0,
			second.handle ? second.handle.implicitHeight : 0,
			contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding)

	spacing: 0
	padding: 0

	second.handle: Details.RangeSliderHandleRight {}
	first.handle: Details.RangeSliderHandleLeft {KeyNavigation.tab: control.second.handle}
	contentItem: Details.RangeSliderContent {}
	background: Details.SliderBackground {}

	Details.SliderToolTip {id: firstToolTip; source: control.first; x: (parent.width * 3/4) - width/2}
	Details.SliderToolTip {id: secondToolTip; source: control.second; x: (parent.width * 1/4) - width/2}

	Details.SliderScaleData {id: ticks}
	Details.SliderLabelsData {id: labels}

	Details.BackgroundBB {}
	Details.ContentItemBB {}
	Details.IndicatorBB {a:first.handle}
	Details.IndicatorBB {a:second.handle}
}
