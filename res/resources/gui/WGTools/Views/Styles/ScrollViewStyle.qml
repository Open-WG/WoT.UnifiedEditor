import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import WGTools.Views.Details 1.0 as Details

ScrollViewStyle {
	id: style

	property real handleSize: 4
	property real hoveredHandleSize: 7
	property color scrollBarBackgroundColor: "transparent"
	property int animDuration: 100

	scrollToClickedPosition: true
	transientScrollBars: true
	minimumHandleLength: 50

	incrementControl: null
	decrementControl: null
	corner: null
	frame: null

	scrollBarBackground: Details.ScrollBarBackground {}
	handle: Details.ScrollBarHandle {}
}
