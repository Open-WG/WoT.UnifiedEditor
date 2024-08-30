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
				source: (model && model.decoration)
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
		}

		Misc.Text {
			id: textArea

			verticalAlignment: Text.AlignVCenter
			text: styleData ? styleData.value : ""
			color: _palette.color1
			opacity: model == null || model.enabled
					? 1.0
					: 0.5
			elide: Text.ElideRight

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
