import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import WGTools.Misc 1.0 as Misc
import WGTools.Controls 2.0 as Controls
import QtQuick.Window 2.11

Window {
	width: 300
	height: 900
	visible: true

	Column {
		id: root
		spacing: 5
		padding: spacing

		anchors.fill: parent

		RowLayout {
			width: parent.width - parent.leftPadding - parent.rightPadding
			spacing: root.spacing

			Repeater {
				model: _palette.themes

				Controls.Button {
					text: modelData
					checked: _palette.theme == modelData
					onClicked: _palette.theme = modelData

					Layout.fillWidth: true
				}
			}
		}

		Column {
			id: colorColumn
			width: parent.width - parent.leftPadding - parent.rightPadding
			height: parent.height - parent.bottomPadding - y
			spacing: 3

			Repeater {
				id: colorRepeater
				model: _palette.colors

				property real delegateHeight: count > 0
					? Math.max(0, colorColumn.height - colorColumn.spacing * (count - 1)) / count
					: 0

				Rectangle {
					id: colorDelegate
					width: parent.width
					height: colorRepeater.delegateHeight
					radius: 3
					implicitHeight: 30
					color: _palette[modelData]

					readonly property bool transparentColor: color == "#00000000"

					border.width: 1
					border.color: transparentColor
						? "black"
						: Qt.rgba(
							Math.abs(colorDelegate.color.r-1),
							Math.abs(colorDelegate.color.g-1),
							Math.abs(colorDelegate.color.b-1), 1)

					Misc.CheckerboardRectangle {
						radius: parent.radius
						visible: parent.transparentColor
						anchors.fill: parent
						border.width: parent.border.width
						border.color: parent.border.color
					}

					Row {
						width: parent.width
						spacing: root.spacing

						anchors {
							verticalCenter: parent.verticalCenter
							left: parent.left
							leftMargin: 20
						}

						Misc.Text {
							text: modelData + ":"
							color: colorDelegate.border.color

							font.bold: true
						}

						TextInput {
							text: colorDelegate.transparentColor ? "transparent" : colorDelegate.color
							color: colorDelegate.border.color
							readOnly: true
							selectByMouse: true
						}
					}
				}
			}
		}
	}
}
