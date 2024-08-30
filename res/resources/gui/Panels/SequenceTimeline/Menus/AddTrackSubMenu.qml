import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQml.Models 2.11

import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc

import "..//Constants.js" as Constants

Instantiator {
	id: instantiator
	
	property var menu: null
	property var menuModel: null
	property var rootIndex: null

	onObjectAdded: {

		if(object.item)
		{
			if(object.isMenu) {
				menu.insertMenu(index, object.item)
			}
			else {
				menu.insertItem(index, object.item )
			}
		}
	}

	onObjectRemoved: {
		if(object.item)
		{
			if(object.isMenu) {
				menu.removeMenu(object.item)
			}
			else {
				menu.removeItem(object.item )
			}
		}
	}

	model: DelegateModel {

		id: delegateModel

		model: instantiator.menuModel
		rootIndex: instantiator.rootIndex

		delegate: QtObject {
			property var item: null
			property var isMenu: false

			Component.onCompleted: {
				if (item != null) {
					return
				}

				var modelIndex = delegateModel.modelIndex(index)
				var numChildren = delegateModel.model.rowCount(modelIndex)

				if (numChildren == 0) {
					item = menuItemComponent.createObject(menu)
				}
				else {
					var component = Qt.createComponent("AddTrackMenu.qml")

					item = component.createObject(menu, {
						"menuModel": instantiator.menuModel,
						"rootIndex": modelIndex,
						"title": model.popupData.label})

					isMenu = true
				}
			}
			
			readonly property Component __component: Component {
				id: menuItemComponent
				MenuItem {
					width: parent.width
					visible: model.popupData.visible

					contentItem: RowLayout {
						spacing: 8

						Image {
							id: icon

							Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
							//Layout.leftMargin: rootItem.leftPadding

							source: model.popupData.icon
							sourceSize.width: Constants.seqTreeIconWidth
							sourceSize.height: Constants.seqTreeIconHeight
						}

						Misc.Text {
							visible: model.popupData.visible
							text: model.popupData.label
							
							Layout.fillWidth: true
							Layout.alignment: Qt.AlignVCenter

							color: Constants.popupTextColor

							font.family: Constants.proximaRg
							font.pixelSize: Constants.fontSize
							font.bold: true
						}
					}

					onTriggered: {
						model.popupData.triggered();
						menuModel.triggered(delegateModel.modelIndex(index))
					}
				}
			}
		}
	}
}
