import QtQuick 2.7
import QtQuick.Layouts 1.3
import Controls 1.0 as SMEControls

Item {
	property var vertexRequestor: null

	anchors.fill: parent

	ColumnLayout {
		anchors.centerIn: parent

		SMEControls.Text {
			Layout.alignment: Qt.AlignHCenter
			text: "Create starting node"
		}

		RowLayout {
			Repeater {
				model: vertexRequestor

				SMEControls.Button {
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
