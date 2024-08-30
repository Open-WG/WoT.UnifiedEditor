import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Misc 1.0 as Misc
import "../../MainWindow/Settings.js" as Settings

Item {
	property int tileTextureWidth: 90
	property int tileTextureHeight: 90
	property int tileSpacing: 2
	property int tileGridColumns: 4

	implicitWidth: childrenRect.x + childrenRect.width
	implicitHeight: childrenRect.y + childrenRect.height

	Component {
		id: tileItem

		Item {
			width: tileTextureWidth
			height: tileTextureHeight

			Image {
				id: image
				anchors.fill: parent
				source: "image://unifiedImageProvider/" + modelData + "?imageIndex=0&R=1&G=1&B=1&A=0"
				fillMode: Image.PreserveAspectFit
				verticalAlignment: Image.AlignVCenter
				horizontalAlignment: Image.AlignHCenter
				cache : false
				asynchronous: true
				smooth: true
			}
			MouseArea {
				id: mouseArea
				anchors.fill: image
				hoverEnabled: true
				onClicked: context.accept(index)
			}
			Rectangle {
				anchors.fill: image
				visible: mouseArea.containsMouse
				color: _palette.color12
				opacity: 0.5
			}
			Rectangle {
				anchors.fill: image
				visible: index == context.selected
				color: "transparent"
				border {
					width: 3
					color: _palette.color12
				}
			}
		}
	}

	Component {
		id: dummyItem
		Rectangle {
			width: tileTextureWidth
			height: tileTextureHeight
			color: _palette.color7
			Text {
				anchors.fill: parent
				verticalAlignment: Text.AlignVCenter
				horizontalAlignment: Text.AlignHCenter
				font {
					family: ControlsSettings.fontFamily
					pixelSize: 12
				}
				color: _palette.color9
				text: "Empty"
			}
		}
	}

	Column {
		Rectangle {
			color: _palette.color8
			width: grid.width
			height: Settings.titlebarHeight

			Misc.IconLabel {
				anchors {
					fill: parent
					leftMargin: 5
					rightMargin: 5
				}
				label.text: "Select Material"
			}
		}
		Rectangle {
			id: grid
			color: _palette.color8
			width: 2 * childrenRect.x + childrenRect.width
			height: 2 * childrenRect.y + childrenRect.height

			Grid {
				x: tileSpacing
				y: tileSpacing
				columns: tileGridColumns
				spacing: tileSpacing
				Repeater {
					model: context.textures
					delegate: tileItem
				}
				Repeater {
					visible: context.count % tileGridColumns !== 0
					model: context.count % tileGridColumns > 0 ? tileGridColumns - context.count % tileGridColumns : 0
					delegate: dummyItem
				}
			}
		}
	}
}