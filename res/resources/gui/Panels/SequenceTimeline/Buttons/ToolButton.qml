import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.impl 2.3 as Impl
import WGTools.Controls.Details 2.0
import Panels.SequenceTimeline 1.0
import "..//Toolbar"

ToolbarCaptionWrapper {
	id: control

	Accessible.name: text

	// properties which will be passed to button
	signal clicked
	property alias checked: button.checked
	property alias checkable: button.checkable

	property alias iconImage: icon.source
	property alias iconColor: icon.color
	property alias iconImageSize: icon.sourceSize
	property alias backgroundRect: background
	property alias action: button.action

	property alias buttonItem: buttonItem

	text: button.text
	focusPolicy: Qt.NoFocus

	Button {
		id: button
		implicitHeight: buttonItem.implicitHeight
		implicitWidth: buttonItem.implicitWidth
		hoverEnabled: true

		Layout.alignment: Qt.AlignHCenter

		onClicked: {
			control.clicked()
		}

		contentItem: Item {
			id: buttonItem
			implicitWidth: Math.max(background.implicitWidth, icon.implicitWidth)
			implicitHeight: Math.max(background.implicitHeight, icon.implicitHeight)

			Layout.alignment: Qt.AlignHCenter
	
			ButtonBackground {
				id: background
				implicitWidth: 36
				implicitHeight: 20
	
				anchors.centerIn: parent
			}
	
			Impl.ColorImage {
				id: icon
				visible: source != undefined
				fillMode: Image.Pad
				opacity: control.enabled ? 1 : 0.25
				source: control.iconSource ? control.iconSource : ""
				
				anchors.centerIn: parent

				Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
			}
		}
		
		background: null
	}
}
