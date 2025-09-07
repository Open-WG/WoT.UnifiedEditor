import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Debug 1.0

ColumnLayout {
	visible: panelContext.isVisible

	Rectangle {
		height: 1
		color: _palette.color3
		Layout.fillWidth: true
	}

	MouseArea {
		height: childrenRect.height
		visible: panelContext.hasSelection
		hoverEnabled: true
		acceptedButtons: Qt.RightButton

		ToolTip.text: panelContext.selectionTooltip
		ToolTip.visible: containsMouse
		ToolTip.delay: ControlsSettings.tooltipDelay
		ToolTip.timeout: ControlsSettings.tooltipTimeout * 100

		Layout.fillWidth: true

		onReleased: {
			panelContext.requestContextMenu(mapToGlobal(mouse.x, mouse.y))
		}

		RowLayout {
			Text {
				color: _palette.color3
				text: "Select"
				rightPadding: ControlsSettings.padding * 1.5
			}

			Repeater {
				model: panelContext.commonModel
				delegate: GameObjectModeFooterDelegate { isSelection: true }
			}

			Rectangle {
				visible: !panelContext.componentModel.isEmpty
				width: 1
				color: _palette.color3
				Layout.fillHeight: true
			}

			Repeater {
				model: panelContext.componentModel
				delegate: GameObjectModeFooterDelegate { isSelection: true }
			}
		}
	}

	Rectangle {
		height: 1
		color: _palette.color3
		visible: panelContext.hasSelection
		Layout.fillWidth: true
	}

	MouseArea {
		height: childrenRect.height
		hoverEnabled: true
		acceptedButtons: Qt.RightButton

		ToolTip.text: panelContext.totalTooltip
		ToolTip.visible: containsMouse
		ToolTip.delay: ControlsSettings.tooltipDelay
		ToolTip.timeout: ControlsSettings.tooltipTimeout * 100

		Layout.fillWidth: true

		onReleased: {
			panelContext.requestContextMenu(mapToGlobal(mouse.x, mouse.y))
		}

		RowLayout {
			Text {
				id: totalLabel
				color: _palette.color3
				text: "Total"
				rightPadding: ControlsSettings.padding * 1.5
			}

			Repeater {
				model: panelContext.commonModel
				delegate: GameObjectModeFooterDelegate { isSelection: false }
			}

			Rectangle {
				visible: !panelContext.componentModel.isEmpty
				width: 1
				color: _palette.color3
				Layout.fillHeight: true
			}

			Repeater {
				model: panelContext.componentModel
				delegate: GameObjectModeFooterDelegate { isSelection: false }
			}
		}
	}
	Rectangle {
		height: 0
		Layout.fillWidth: true
	}
}
