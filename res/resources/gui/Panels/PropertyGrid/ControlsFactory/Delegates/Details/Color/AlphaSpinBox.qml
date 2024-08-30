import QtQuick 2.7
import QtQuick.Templates 2.2 as T
import WGTools.Controls 2.0 as Controls
import "../SpinBox"
import "../Slider"

SpinBox {
	id: control
	implicitWidth: 81
	leftPadding: background.preview.width + spacing
	postfixText: "%"
	visible: valueData != undefined;

	background: AlphaSpinBoxBackground {}

	T.Button {
		width: control.background.preview.width
		height: control.height
		onClicked: popupLoader.sourceComponent = comp
	}

	Loader {
		id: popupLoader
		y: control.height + 5
	}

	Component {
		id: comp

		Controls.Popup {
			id: popup
			modal: true
			closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside | T.Popup.CloseOnReleaseOutside

			onOpened: slider.forceActiveFocus()
			onClosed: popupLoader.sourceComponent = null
			Component.onCompleted: open()

			Binding {
				target: popup.background
				property: "color"
				value: _palette.color9
			}

			Slider {
				id: slider
				width: parent.width
				ticks.visible: false
				labels.visible: false
				valueData: control.valueData
				from: 0.0
				to: 100.0

				Connections {
					target: slider.controller
					onModified: {
						if (commit) {
							popup.close()
						}
					}
				}
			}
		}
	}
}
