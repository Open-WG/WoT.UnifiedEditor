import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc

Item {
	property var vertexRequestor: null

	anchors.fill: parent

	ColumnLayout {
		anchors.centerIn: parent

		Misc.Text {
			Layout.alignment: Qt.AlignHCenter
			text: "Create starting node"
		}

		RowLayout {
			Repeater {
				model: vertexRequestor

				Button {
					Layout.minimumWidth: 100

					height: 20

					text: itemLabel

					onClicked: {
						vertexRequestor.requestVertexCreation(itemID, 0, 0)
					}
				}
			}
		}
	}
}
