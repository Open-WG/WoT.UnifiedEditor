import QtQuick 2.11
import QtQuick.Window 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QtQml.Models 2.11
import WGTools.Controls.Details 2.0 as ControlsDetails
import WGTools.Misc 1.0 as Misc
import WGTools.Controls 2.0 as Controls2

Control {
	id: control

	implicitWidth: button.implicitWidth
	implicitHeight: button.implicitHeight

	property var selectableData
	property var filterData

	Controls2.Button {
		id: button
		text: control.selectableData ? 
			control.selectableData.labels[control.selectableData.currentIndex] : "Button"

		anchors.fill: parent

		implicitWidth: menu.implicitWidth

		onClicked: {
			if (!menu.openned && !menu.visible)
				menu.open()
		}

		Binding on down {value: menu.openned || menu.visible}

		contentItem: RowLayout {
			spacing: 6

			Misc.Text {
				text: button.text
				font: button.font

				Layout.fillWidth: true
				Layout.fillHeight: true
			}

			ControlsDetails.ComboBoxIndicator {
				down: button.down
			}
		}
	}

	Controls2.Menu {
		id: menu

		x: button.x
		y: button.height + 6

		implicitWidth: 142

		modal: true

		Controls2.ButtonGroup { id: switchGroup }

		Repeater {
			model: control.selectableData ? control.selectableData.labels : null

			Controls2.MenuItem {
				text: modelData
				checkable: true
				ButtonGroup.group: switchGroup
				Binding on checked { value: control.selectableData.currentIndex == index }
				onClicked: control.selectableData.currentIndex = index
			}
		}

		Repeater {
			model: control.filterData.length ? 1 : 0

			Controls2.MenuSeparator { }
		}

		Repeater {
			model: control.filterData.length ? 1 : 0

			Controls2.MenuHeader {
				text: "Filter by:"
			}
		}

		Repeater {
			model: control.filterData

			Repeater {
				property var currentFilterData: modelData

				model: ObjectModel {
					id: itemModel

					property var titleInstantiator: Instantiator {
						model: currentFilterData.title.length ? 1 : 0

						onObjectAdded: itemModel.insert(0, object)

						Controls2.MenuHeader {
							text: currentFilterData.title
						}
					}

					property var labelsInstantiator: Instantiator {
						model: currentFilterData.labels

						onObjectAdded: itemModel.append(object)

						Controls2.MenuItem {
							text: modelData
							checkable: true

							Binding on checked {
								value: currentFilterData.currentIndex == index
							}

							onClicked: {
								if (currentFilterData.currentIndex == index) {
									currentFilterData.currentIndex = -1
								} else {
									currentFilterData.currentIndex = index
								}
							}
						}
					}
				}
			}
		}
	}
}
