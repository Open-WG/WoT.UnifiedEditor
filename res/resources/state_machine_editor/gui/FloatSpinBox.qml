import QtQuick 2.7
import QtQuick.Controls 2.3
import WGTDoubleSpinBox 1.0
import SMEDoubleValidator 1.0

WGTDoubleSpinBox {
	id: spinBox
	from: 0
	to: 999999

	decimals: 3
	inputMethodHints: Qt.ImhFormattedNumbersOnly

	editable: true
	hoverEnabled: true

	font.pixelSize: 12
	font.family: "Proxima Nova Rg"
	font.bold: true

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)
	
	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		contentItem.implicitHeight + topPadding + bottomPadding,
		0)

	background: Rectangle {
		color: "black"
		radius: 3
	}

	validator: SMEDoubleValidator {
		bottom: Math.min(spinBox.from, spinBox.to)
		top: Math.max(spinBox.from, spinBox.to)
		notation: DoubleValidator.StandardNotation
		decimals: spinBox.decimals
	}

	contentItem: TextInput {
		id: spinBoxContent

		Binding on text {
			value: displayText
		}
		horizontalAlignment: TextInput.AlignLeft
		verticalAlignment: TextInput.AlignVCenter

		color: "white"
		selectByMouse: true
		clip: true
		validator: spinBox.validator
		inputMethodHints: spinBox.inputMethodHints
		font: spinBox.font
		leftPadding: spinBox.spacing

		onAccepted: {
			spinBox.parent.forceActiveFocus()
		}

		cursorDelegate: Rectangle {
			id: cursorDelegate

			width: spinBoxContent.cursorRectangle.width
			height: spinBoxContent.cursorRectangle.height
			visible: spinBoxContent.activeFocus
			color: "white"
			antialiasing: false
			state: "on"

			Connections {
				target: spinBoxContent
				onCursorPositionChanged: {
					state = "on"
					timer.restart()
				}
			}

			Timer {
				id: timer
				running: cursorDelegate.visible
				repeat: true
				interval: Qt.styleHints.cursorFlashTime / 2
				onTriggered: cursorDelegate.state = cursorDelegate.state == "on" ? "off" : "on"
			}

			states: [
				State {
					name: "on"
					PropertyChanges { target: cursorDelegate; opacity: 1 }
				},
				State {
					name: "off"
					PropertyChanges { target: cursorDelegate; opacity: 0 }
				}
			]

			transitions: [
				Transition {
					from: "on"
					to: "off"
					NumberAnimation { property: "opacity"; duration: 50 }
				}
			]
		}

		onActiveFocusChanged: {
			if (!activeFocus) {
				deselect()
			}
		}

		onWidthChanged: {
			ensureVisible(0)
		}
	}

	padding: 0
	spacing: 3

	textFromValue: function(value, locale, decimals) {
		return Number(value).toLocaleString(locale, 'f', decimals)
	}

	valueFromText: function(text, locale) {
		return Number.fromLocaleString(locale, text)
	}
}