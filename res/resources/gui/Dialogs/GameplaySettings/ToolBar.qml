import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls

Item {
	anchors.leftMargin: 10
	anchors.rightMargin: 10

	MouseArea {
		anchors.fill: parent
		onClicked: root.forceActiveFocus()
	}

	RowLayout {
		Layout.fillHeight: true
		Layout.alignment: Qt.AlignLeft
		anchors.verticalCenter: parent.verticalCenter

		Controls.CheckBox {
			text: "Show grid"

			Binding on checked {
				value: context.showGrid
			}

			onCheckedChanged: {
				context.showGrid = checked
			}
		}

		Controls.CheckBox {
			text: "Show numbers"
			Binding on checked {
				value: context.showNumbers
			}

			onCheckedChanged: {
				context.showNumbers = checked
			}
		}
	}

	RowLayout {
		Layout.fillHeight: true

		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter

		Controls.Button {
			text: "Export draft minimap"

			onClicked: context.exportDraftMinimap()
		}

		Controls.Button {
			text: "Export minimap"

			onClicked: context.exportMinimap()
		}

		Controls.Button {
			text: "Apply"

			enabled: context.canSave

			onClicked: context.apply()
		}

		Controls.Button {
			text: "Cancel"

			onClicked: context.cancel()
		}
	}
}
