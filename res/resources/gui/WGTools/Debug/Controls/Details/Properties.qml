import QtQuick 2.11
import QtQuick.Controls 2.4 as C2
import WGTools.Controls 2.0
import QtQuick.Controls 1.4 as C1
import QtQuick.Layouts 1.11
import WGTools.Debug 1.0

Flickable {
	id: root
	property Item source
	property var properties: {
		var res = []

		for (var key in source) {

			if (filter.text.length && key.indexOf(filter.text) == -1)
				continue

			res.push(key)
		}

		return res
	}

	contentWidth: pane.implicitWidth
	contentHeight: pane.implicitHeight

	implicitWidth: 400
	implicitHeight: contentHeight

	clip: true

	Pane {
		id: pane
		width: root.width

		Column {
			id: column
			width: parent.width
			spacing: 2

			C2.GroupBox {
				width: parent.width

				ColumnLayout {
					width: parent.width
					spacing: column.spacing
					
					Row{
						CheckBox {
							id: debugDraw
							text: "debug draw"

							onToggled: debugMode = checked
							Binding on checked { value: debugMode }
						}
						Button {
							text: "Set Focus"
							onClicked: root.source.forceActiveFocus(Qt.TabFocusReason)
						}
					}

					RowLayout {
						spacing: column.spacing
						Layout.fillWidth: true

						TextField {
							id: filter
							selectByMouse: true

							Layout.fillWidth: true
						}

						Button {text: "x"; onClicked: filter.text = ""}
					}
				}
			}

			C2.GroupBox {
				width: parent.width

				Column {
					width: parent.width
					spacing: column.spacing

					Repeater {
						model: root.properties

						RowLayout {
							width: parent.width
							spacing: column.spacing
							visible: root.source && root.source.hasOwnProperty(modelData) && loader.item != null

							Label {
								text: modelData
								Layout.preferredWidth: Math.max(implicitWidth, 200)
							}

							Loader {
								id: loader
								clip: true

								Layout.fillWidth: true
								Binding {target: loader.item; property: "width"; value: loader.width}

								sourceComponent: {
									let type = typeof root.source[modelData]

									if (type == "boolean") 
										return booleanComponent

									if (type == "object")
										return null

									if (type == "function")
										return null

									return stringComponent 
								}

								Component {
									id: booleanComponent

									CheckBox {
										text: modelData
										onToggled: root.source[modelData] = checked
										Binding on checked {value: root.source[modelData]}
									}
								}

								Component {
									id: stringComponent

									RowLayout {
										TextField {
											selectByMouse: true
											text: root.source[modelData]
											onTextEdited: root.source[modelData] = text
											Layout.fillWidth: true
										}

										Button {
											text: "reset"
											implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
											hoverEnabled: true
											onClicked: root.source[modelData] = undefined
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}

	ScrollBar.vertical: ScrollBar {}
}
