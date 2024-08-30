import QtQuick 2.11
import WGTools.Controls 2.0 as Controls

Controls.TextField {
	id: rextField

	signal alertFinished()

	function alert() {
		alertAnimation.restart()
	}

	width: Math.min(Math.max(30, contentWidth + leftPadding + rightPadding), parent.width - x)
	wrapMode: TextInput.NoWrap
	
	font.bold: true

	SequentialAnimation {
		id: alertAnimation
		loops: 1

		onRunningChanged: if (running == false) {
			rextField.alertFinished()
		}

		ColorAnimation { target: rextField.background; property: "color"; to: "red"; duration: 500 }
		ColorAnimation { target: rextField.background; property: "color"; to: _palette.color9;  duration: 500 }
	}
}
