import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

Rectangle {
	implicitWidth: 400
	implicitHeight: 400
	color: _palette.color7

	ColumnLayout {
		id: rootColumn
		spacing: 0

		anchors.fill: parent

		TabBar {
			id: bar
			Layout.fillWidth: true

			TabButton {
				text: qsTr("Import")
			}

			TabButton {
				text: qsTr("Export")
			}
		}

		StackLayout {
			currentIndex: bar.currentIndex

			Layout.margins: 10

			ImportPage {
			}

			ExportPage {
			}
		}
	}
}
