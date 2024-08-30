import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Item {
	id: root

	property string separator: '/'
	property string path: ""
	property string homeText: "Home"

	property Component homeItemDelegate: null
	property Component itemDelegate: null
	property Component separatorDelegate: null

	property bool endingSlash: true
	property bool selectLast: true

	property alias spacing: row.spacing
	property int textHeight: 15
	property real iconHeight: 0

	signal selected(string selectedPath)

	implicitWidth: row.width
	implicitHeight: 20

	QtObject {
		id: p

		readonly property Component homeItemDelegate: root.homeItemDelegate !== null ? root.homeItemDelegate : defaultHomeItemDelegate
		readonly property Component itemDelegate: root.itemDelegate !== null ? root.itemDelegate : defaultItemDelegate
		readonly property Component separatorDelegate: root.separatorDelegate !== null ? root.separatorDelegate : defaultSeparatorDelegate
		readonly property real animationDuration: 100
	}

	Component {
		id: defaultHomeItemDelegate

		Item {
			width: iconLabel.width

			Misc.IconLabel {
				id: iconLabel
				height: parent.height
				spacing: 5

				anchors.centerIn: parent

				icon.source: "image://gui/icon-home?color=" + encodeURIComponent(_palette.color2)
				icon.height: (styleData.iconHeight != 0) ? styleData.iconHeight : icon.implicitHeight

				label.text: styleData.value
				label.color: styleData.hovered ? _palette.color1 : _palette.color2
				label.font.pixelSize: styleData.textHeight
				label.font.bold: styleData.selected

				Behavior on label.color {
					enabled: !_palette.themeSwitching
					ColorAnimation { duration: p.animationDuration }
				}
			}
		}
	}

	Component {
		id: defaultItemDelegate

		Item {
			width: txt.width

			Accessible.name: txt.text

			Misc.Text {
				id: txt
				text: styleData.value
				color: styleData.hovered ? _palette.color1 : _palette.color2
				font.pixelSize: styleData.textHeight
				font.bold: styleData.selected
				anchors.centerIn: parent
				
				Behavior on color {
					enabled: !_palette.themeSwitching
					ColorAnimation { duration: p.animationDuration }
				}
			}
		}
	}

	Component {
		id: defaultSeparatorDelegate

		Item {
			width: icon.width

			Image {
				id: icon
				source: "image://gui/icon-breadcrumb-arrow?color=" + encodeURIComponent(_palette.color2)
				anchors.centerIn: parent
			}
		}
	}

	Row {
		id: row
		height: parent.height

		Repeater {
			id: repeater
			model: (root.path !== "") ? [root.homeText].concat(root.path.split(root.separator)) : [root.homeText]
			delegate: Item {
				id: item

				readonly property bool selected: (item.Positioner.isLastItem && root.selectLast)

				width: separatorLoader.visible ? (itemLoader.width + separatorLoader.width + row.spacing) : itemLoader.width
				height: parent.height
				
				Loader {
					id: itemLoader
					height: parent.height
					sourceComponent: item.Positioner.isFirstItem ? p.homeItemDelegate : p.itemDelegate

					anchors.left: parent.left

					property QtObject styleData: QtObject {
						readonly property string value: modelData
						readonly property int textHeight: root.textHeight
						readonly property real iconHeight: root.iconHeight
						readonly property bool hovered: mouseArea.containsMouse
						readonly property bool selected: item.selected
					}
				}

				Loader {
					id: separatorLoader
					height: parent.height
					visible: !item.Positioner.isLastItem || root.endingSlash
					sourceComponent: visible ? p.separatorDelegate : null

					anchors.right: parent.right
				}

				MouseArea {
					id: mouseArea
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor

					anchors.fill: itemLoader

					onClicked: {
						if (model.index == 0) {
							root.selected("")
						} else {
							var subModel = repeater.model.slice(1, model.index + 1);
							root.selected(subModel.join(root.separator))
						}
					}
				}
			}
		}
	}
}
