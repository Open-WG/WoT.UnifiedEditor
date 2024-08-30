import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQml.Models 2.11
import WGTools.Misc 1.0 as Misc
import WGTools.Controls 2.0 as Controls
import WGTools.Utils 1.0
import "../Settings.js" as Settings

Item {
	id: root
	implicitWidth: layout.implicitWidth
	readonly property var itemModel: model
	readonly property bool modified: itemModel && itemModel.modified ? itemModel.modified : false

	RowLayout {
		id: layout
		anchors.fill: parent
		spacing: Settings.defaultSpacing

		Item {
			id: iconHolder

			Layout.fillHeight: true
			implicitWidth: Settings.iconWidth
			visible: root.width > implicitWidth

			Repeater {
				model: styleData ? styleData.depth : null

				Rectangle {
					width: 1
					height: parent.height
					color: "#4DFFFFFF"

					x: - (index *  Settings.treeItemIntend +  Settings.treeItemIntend +  Settings.treeItemIntend / 2)
				}
			}

			Image {
				source: (model && model.decoration && model.decoration != "<unnamed type>")
					? "image://gui/" + model.decoration
					: ""

				// enable scale after icons will be realized in vectors svg format
				// scale: styleData && styleData.selected
				// 	? 1.25
				// 	: 1.0

				opacity: model == null || model.enabled
					? 1.0
					: 0.5

				width: Settings.iconWidth
				height: Settings.iconWidth

				anchors.verticalCenter: iconHolder.verticalCenter
				anchors.left: iconHolder.left

				Behavior on opacity {
					NumberAnimation { duration: 500; easing.type: Easing.OutCubic}
				}

				// Behavior on scale {
				// 	NumberAnimation { duration: 500; easing.type: Easing.OutCubic}
				// }
			}


			Canvas {
			    anchors.fill: parent
                property var color: model != null && model.state == 1
			        ? "red"
			        : model != null && model.state == 2
			        ? "yellow"
			        : null
			    onColorChanged: requestPaint()
			    onPaint: {
				    var ctx = getContext("2d")
				    ctx.reset()
				    if (!color) {
					    return;
				    }
				    ctx.fillStyle = color

				    var ellipseX = Settings.iconWidth - 8
				    var ellipseY = Settings.iconWidth - 5

				    ctx.ellipse(ellipseX, ellipseY, 8, 8)
				    ctx.fill()
			    }
		    }
		}

		Misc.Text {
			id: textArea

			verticalAlignment: Text.AlignVCenter
			text: styleData ? root.modified ? styleData.value + "*" : styleData.value : ""
			color: model != null && model.state == 1
			    ? "red"
			    : model != null && model.state == 2
			    ? "yellow"
			    : "white"
			opacity: model == null || model.enabled
					? 1.0
					: 0.5
			elide: Text.ElideRight

			font.italic: root.modified
			font.bold: root.modified

			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.alignment: Qt.AlignLeft
		}

		Misc.Text {
			id: textCountItems
			text: model != null && model.count != null && typeof model.count != 'undefined' ? model.count + " items" : ""
			visible: text != ""
			horizontalAlignment: Text.AlignRight
			verticalAlignment: Text.AlignVCenter
			color: _palette.color3
			elide: Text.ElideRight

			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.alignment: Qt.AlignRight
		}

		Item {
			id: buttonHolder
			visible: repeater.count > 0
			Layout.fillHeight: true

			Binding on implicitWidth {
				delayed: true
				value: buttonHolder.calcWidth()
			}

			function calcWidth() {
				let w = 0

				for (var i=0; i<repeater.count; ++i) {
					let item = repeater.itemAt(i)
					if (item && item.iconVisible) {
						w = Math.max(w, -item.x)
					}
				}

				return w
			}

			Item {
				id: buttons
				height: parent.height
				anchors.right: parent.right

				Repeater {
					id: repeater
					model: root.itemModel && root.itemModel.rowButtonsModel ? root.itemModel.rowButtonsModel : null
					delegate: IconButton {
						id: self
						x: -(model.posIndex * (width + 5) + width)
						y: (parent.height - height) / 2
					}
				}
			}
		}
	}
}
