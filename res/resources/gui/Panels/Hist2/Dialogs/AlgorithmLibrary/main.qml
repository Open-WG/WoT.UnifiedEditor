import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Window 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import "../../Details" as Details

Rectangle {
	id: root
	implicitWidth: 300
	implicitHeight: 417
	color: _palette.color8

	ColumnLayout {
		id: layout
		width: parent.width
		height: parent.height
		spacing: ControlsSettings.spacing

		ListView {
			id: view
			boundsBehavior: Flickable.StopAtBounds
			focus: true
			clip: true
			currentIndex: context.currentIndex
			model: context.algorithms

			// Reimplement arrow keys handling to use context current index instead of view current index
			Keys.onPressed: {
				if (event.key == Qt.Key_Down) {
					if (context.currentIndex + 1 < view.count) {
						++context.currentIndex;
					}
					event.accepted = true;
				}
				if (event.key == Qt.Key_Up) {
					if (context.currentIndex > 0) {
						--context.currentIndex;
					}
					event.accepted = true;
				}
			}

			delegate: AlgorithmDelegate {

				id: algorithmItem

				MouseArea {
					id: mouseArea
					acceptedButtons : Qt.LeftButton | Qt.RightButton
					anchors.fill : parent

					onDoubleClicked: showInput()
					onClicked: {
						if (context.currentIndex != index) {
							context.currentIndex = index;
						}

						if (mouse.button == Qt.RightButton) {
							contextMenu.popupEx();
						}
					}
					Component.onCompleted: {
						// Activate editor window on closing menu popup
						contextMenu.closed.connect(activateWindow);
					}

					function activateWindow() {
						if (!Window.activated) {
							Window.window.requestActivate(); 
						}
					}

					function showInput() {
						input.visible = true;
						input.forceActiveFocus();
						input.text = model.name;
					}

					Menu {
						id: contextMenu

						MenuItem {
							text : "Rename"
							onClicked: {
								mouseArea.showInput();
							}
						}

						MenuItem {
							text : "Copy"
							onClicked: {
								context.copyAlgorithm(algorithmItem.contentItem.text);
							}
						}

						MenuItem {
							text : "Remove"
							onClicked: {
								context.deleteAlgorithm(algorithmItem.contentItem.text);
							}
						}
					}
				}

				AlgorithmNameTextField {
					id: input
					width: view.width
					visible: false

					function algorithmNameAccepted() {
						return (contentItem.text == text || context.renameAlgorithm(contentItem.text, text));
					}
				}

				z: view.count - index // Trick that allows error message to overlap other items
			}

			Layout.fillWidth: true
			Layout.fillHeight: true

			ScrollBar.vertical: ScrollBar {}
		}

		Details.Separator {
			Layout.fillWidth: true
		}

		Component {
			id: newAlgorithmTextField

			AlgorithmNameTextField {
				width: view.width

				function algorithmNameAccepted() {
					return context.addAlgorithm(text);
				}

				onEditingFinished: Qt.callLater(function() { view.header = null; })
			}
		}

		Button {
			text: "Add New Algorithm"
			Layout.fillWidth: true
			Layout.margins: ControlsSettings.padding
			Layout.topMargin: 0

			onClicked: {
				view.header = newAlgorithmTextField;
				view.headerItem.z = view.count + 1; // Allows error message to overlap other items
				view.headerItem.forceActiveFocus();
			}
		}
	}
}
