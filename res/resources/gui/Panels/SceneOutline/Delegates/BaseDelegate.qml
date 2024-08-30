import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import WGTools.Misc 1.0 as Misc
import WGTools.Controls 2.0 as Controls
import "../Settings.js" as Settings
import WGTools.Utils 1.0

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

			readonly property real buttonSize: 16 // pixel size of icon.png
			readonly property real buttonSpacing: 5
			readonly property real buttonsWidth: {
				var sum = 0;
				for(var i = 0; i < repeater.count; ++i) {
					if(repeater.itemAt(i).visible){
						sum += (buttonSize + buttonSpacing);
					}
				}
				return sum;
			}

			implicitWidth: buttonsWidth
			Layout.fillHeight: true

			Repeater {
				id: repeater
				model: root.itemModel && root.itemModel.rowButtonsModel ? root.itemModel.rowButtonsModel : 0

				delegate: Item {
					width: buttonHolder.buttonSize
					height: buttonHolder.buttonSize

					readonly property bool iconButtonActive: {
						if (!model.showOnlyOnHover || model.checked)
						{
							return true
						}
						else
						{
							return (root.itemModel != undefined && typeof root.itemModel["hoverRole"] != "undefined") ? root.itemModel.hoverRole : false
						}
					}

					x: model.posIndex < 0
						? model.posIndex == -1
							? Math.max(0, parent.width - buttonHolder.buttonSize)
							: Math.max(0, parent.width + (buttonHolder.buttonSize + buttonHolder.buttonSpacing) * model.posIndex)
						: model.posIndex * (buttonHolder.buttonSize + buttonHolder.buttonSpacing)
					z: -model.posIndex

					anchors.verticalCenter: parent.verticalCenter

					Item {
						id: icon
						anchors.fill: parent
						visible: iconButtonActive && model

						Loader {
							id: loaderItem
							source: "ButtonDelegates/" + model.iconType + ".qml"
							anchors.fill: parent
							Accessible.name: model.decoration ? model.decoration.split('/').pop() : iconColour
						}

						ColorOverlay {
							anchors.fill: loaderItem
							source: loaderItem
							color: model != null ? model.iconColour : "transparent"
							Accessible.ignored: true
						}

						MouseArea {
							anchors.fill: parent
							Accessible.ignored: true

							onClicked: {
								model.action.invoke(sceneBrowserContext.assetSelection);
							}
						}
					}

					// TODO: display by HoverHandler from Qt 5.12
					// Controls.ToolTip.text: model.tooltip
					// Controls.ToolTip.visible: model.tooltip.length > 0 && root.model.hoverRole
					// Controls.ToolTip.delay: 500
					// Controls.ToolTip.timeout: 1000

				}
			}
		}
	}
}
