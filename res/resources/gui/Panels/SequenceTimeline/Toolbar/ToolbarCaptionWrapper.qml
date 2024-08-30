import QtQuick 2.11
import QtQuick.Layouts 1.4
import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc
import Panels.SequenceTimeline 1.0
import Panels.SequenceTimeline.Buttons 1.0

Control {
	id: control

	default property alias data: layout.data
	property alias text: caption.text

	contentItem: ColumnLayout {
		id: content
		width: control.width - control.leftPadding - control.rightPadding
		spacing: 0
		
		ColumnLayout {
			id: layout
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignHCenter
		}

		Misc.Text {
			id: caption
			opacity: control.text != "" ? 1.0 : 0.0
			color: control.enabled ? _palette.color1 : _palette.color3
			enabled: false
			horizontalAlignment: Text.AlignHCenter
			elide: Text.ElideRight

			Layout.fillWidth: true
		}
	}
}
