import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.Misc 1.0 as Misc
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import "Settings.js" as Settings

Rectangle {
	id: root

	signal activatePressed()
	signal contextMenuClicked()
	signal closeClicked()

	z: p.hovered
		? 100
		: p.active
			? model.index
			: 0

	color: p.active
		? _palette.color8
		: p.hovered
			? _palette.color6
			: _palette.color9

	Accessible.name: model ? model.display : ""

	Behavior on color {
		enabled: !_palette.themeSwitching
		ColorAnimation { duration: Settings.tabHighlightingDuration; easing.type: Easing.OutQuad }
	}

	QtObject {
		id: p // private
		readonly property bool hovered: mouseArea.containsMouse || closeButton.containsMouse
		readonly property bool active: model != null ? model.active : false
	}

	Misc.IconLabel {
		spacing: 2

		label.text: model ? model.display : ""

		anchors.fill: parent
		anchors.leftMargin: 5
		anchors.rightMargin: closeButton.width

		icon.source: model && model.decoration ? "image://gui/" + model.decoration : ""
	}

	ToolTip.text: model ? model.assetPath : ""
	ToolTip.visible: mouseArea.containsMouse
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout

	MouseArea {
		id: mouseArea
		hoverEnabled: true
		acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
		onPressed: {
			switch (mouse.button)
			{
				case Qt.LeftButton:
					root.activatePressed()
					break
			}
		}
		onClicked: {
			switch (mouse.button)
			{
				case Qt.MiddleButton:
					root.closeClicked()
					break

				case Qt.RightButton:
					contextMenuClicked()
					break
			}
		}

		anchors.fill: parent
	}

	TabCloseButton {
		id: closeButton
		width: parent.height
		height: parent.height
		acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
		onClicked: {
			switch (mouse.button)
			{
				case Qt.RightButton:
				case Qt.MiddleButton:
					break
				case Qt.LeftButton:
					root.closeClicked()
					break
			}
		}

		Accessible.name: "Close"

		anchors.right: separator.left
	}

	Rectangle {
		id: separator
		implicitWidth: 1
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.topMargin: 3
		anchors.bottom: parent.bottom
		anchors.bottomMargin: anchors.topMargin

		color: _palette.color8
	}
}
