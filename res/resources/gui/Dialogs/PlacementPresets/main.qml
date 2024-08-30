import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.Misc 1.0 as Misc

Rectangle {
	id: root

	property var title: "Item Placement Presets"
	Accessible.name: title

	implicitWidth: 400
	implicitHeight: 500
	color: _palette.color7
	focus: true

	MouseArea {
		anchors.fill: parent
		onClicked: root.forceActiveFocus()
	}

	ColumnLayout {
		id: mainColumnLayout

		spacing: 5
		anchors.fill: parent

		RowLayout {
			Layout.alignment: Qt.AlignTop
			Layout.topMargin: 5
			Layout.leftMargin: 5
			Layout.rightMargin: 5

			Misc.Text {
				text: "Current Preset"
			}

			Controls.ComboBox {
				Accessible.name: "Current Preset"
				Layout.fillWidth: true

				model: context.presetList
				currentIndex: context.currentIndex

				onActivated: context.currentIndex = currentIndex
			}

			Controls.Button {
				id: addButton
				Accessible.name: "Add"

				icon.source: "image://gui/add"

				onClicked: context.addPreset()
			}

			Controls.Button {
				id: deleteButton
				Accessible.name: "Delete"

				enabled: context.editable

				icon.source: "image://gui/delete"

				onClicked: context.removeCurrentPreset()
			}

			Controls.Button {
				id: renameButton
				Accessible.name: "Rename"

				enabled: context.editable

				icon.source: "image://gui/edit"

				onClicked: context.renameCurrentPreset()
			}
		}

		Rectangle {
			Layout.preferredHeight:1
			Layout.fillWidth: true

			color: "black"
		}

		Misc.Text {
			Layout.alignment: Qt.AlignTop
			Layout.leftMargin: 5
			Layout.rightMargin: 5

			text: "Random Rotation (Yaw, Pitch and Roll degrees)"
		}

		RowLayout {
			Accessible.name: "Rotation"

			Layout.alignment: Qt.AlignTop
			Layout.leftMargin: 5
			Layout.rightMargin: 5

			Controls.Button {
				Accessible.name: "Lock"
				enabled: context.editable
				icon.source: context.rotationLocked ? "image://gui/lock" : "image://gui/unlock"
				onClicked: context.rotationLocked = !context.rotationLocked
			}

			ColumnLayout {
				Repeater {
					model: ["yaw", "pitch", "roll"]

					PresetSlider {
						Layout.alignment: Qt.AlignTop
						Accessible.name: label.text

						label.text: modelData.charAt(0).toUpperCase()

						lowLimit: -360
						highLimit: 360
						lowVal: context[modelData + "Low"]
						highVal: context[modelData + "High"]

						onLowModified: context[modelData + "Low"] = val
						onHighModified: context[modelData + "High"] = val

						Controls.Button {
							enabled: context.editable
							icon.source: "image://gui/revert-value"
							Accessible.name: "Undo"

							onClicked: {
								if (context[modelData + "High"] < 0) {
									context[modelData + "High"] = 0
									context[modelData + "Low"] = 0
								}
								else {
									context[modelData + "Low"] = 0
									context[modelData + "High"] = 0
								}
							}
						}
					}
				}
			}
		}

		Rectangle {
			Layout.preferredHeight: 1
			Layout.fillWidth: true

			color: "black"
		}

		Misc.Text {
			Layout.alignment: Qt.AlignTop
			Layout.leftMargin: 5
			Layout.rightMargin: 5

			text: "Random Scale (normalized values per axis)"
		}

		Controls.CheckBox {
			Accessible.name: text
			Layout.alignment: Qt.AlignTop
			Layout.leftMargin: 5
			Layout.rightMargin: 5

			text: "Uniform"
			checked: context.uniformScale
			enabled: context.editable

			onClicked: context.uniformScale = checked
		}

		RowLayout {
			Accessible.name: "Scale"
			Layout.alignment: Qt.AlignTop
			Layout.leftMargin: 5
			Layout.rightMargin: 5

			Controls.Button {
				Accessible.name: "Lock"
				enabled: context.editable
				icon.source: context.scaleLocked ? "image://gui/lock" : "image://gui/unlock"
				onClicked: context.scaleLocked = !context.scaleLocked
			}

			ColumnLayout {
				Repeater {
					model: ["x", "y", "z"]

					PresetSlider {
						Layout.alignment: Qt.AlignTop
						Accessible.name: label.text

						label.text: modelData.toUpperCase()

						lowLimit: -10
						highLimit: 10
						lowVal: context[modelData + "ScaleLow"]
						highVal: context[modelData + "ScaleHigh"]

						onLowModified: context[modelData + "ScaleLow"] = val
						onHighModified: context[modelData + "ScaleHigh"] = val

						Controls.Button {
							enabled: context.editable
							icon.source: "image://gui/revert-value"
							Accessible.name: "Undo"

							onClicked: {
								if (context[modelData + "ScaleHigh"] < 0) {
									context[modelData + "ScaleHigh"] = 1
									context[modelData + "ScaleLow"] = 1
								}
								else {
									context[modelData + "ScaleLow"] = 1
									context[modelData + "ScaleHigh"] = 1
								}
							}
						}
					}
				}
			}
		}

		Item {
			Layout.fillHeight: true
		}
	}
}
