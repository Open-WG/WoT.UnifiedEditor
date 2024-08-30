import QtQuick 2.11
import WGTools.Controls.impl 1.0
import WGTools.Misc 1.0 as Misc
import "../../../../Common" as Common

Common.ClosableDelegateWrapper {
	id: wrapper
	height: parent.height
	color: _palette.color5

	function getSysFilterId(filter) {
		if (filter.length == 0)
			return ""

		let equalPos = filter.indexOf('=')
		return filter.substr(0, equalPos) + (equalPos != -1 ? ":" : "")
	}

	function getSysFilterParam(filter) {
		if (filter.length == 0)
			return ""

		return filter.substr(filter.indexOf('=')+1)
	}

	Row {
		property string text: model.display
		Rectangle {
			implicitWidth: filterNameLabel.width + 10
			implicitHeight: 18
			color: Color.transparent(_palette.color1, 0.15)

			Misc.Text {
				id: filterNameLabel
				text: getSysFilterId(model.display)
				enabled: false
				color: "#FFFFFF"
				size: "Small"
				anchors.centerIn: parent
			}
		}

		Misc.Text {
			enabled: false
			leftPadding: 5
			rightPadding: wrapper.closable ? 0 : leftPadding
			text: getSysFilterParam(model.display)
			size: "Small"

			font.bold: true

			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: 1
		}
	}
}
