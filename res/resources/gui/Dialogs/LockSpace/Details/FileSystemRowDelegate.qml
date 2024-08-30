import QtQuick 2.11
import WGTools.Views.Details 1.0 as ViewDetails

ViewDetails.RowDelegate {
	Rectangle {
		visible: typeof model != "undefined" && model ? model.myLock : false
		anchors.fill: parent

		color: "#7ed321"
		opacity: 0.4
	}

	Rectangle {
		visible: typeof model != "undefined" && model ? model.isBusy : false
		anchors.fill: parent

		color: "red"
		opacity: 0.4
	}
}