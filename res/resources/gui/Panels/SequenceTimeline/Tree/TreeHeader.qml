import QtQuick 2.11
import QtQuick.Layouts 1.4
import WGTools.Controls 2.0

Item {
	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	RowLayout {
		id: layout
		width: parent.width
		height: parent.height
		spacing: 5

		Label {
			text: "Sequence:"
			leftPadding: 5
			font.bold: true
		}

		Label {
			color: "white"
			verticalAlignment: Text.AlignVCenter

			text: context.sequenceOpened
				? context.sequenceModel.sequenceName
				: "No Sequence Opened"

			Layout.fillWidth: true
		}
	}
}
