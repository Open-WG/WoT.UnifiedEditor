import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

ColumnLayout {

	property bool isFiltering: panelContext.numFilteredElements < panelContext.numElements

	Rectangle {
		height: 1
		color: _palette.color3
		Layout.fillWidth: true
	}

	RowLayout {

		Text {
			id: totalText
			topPadding: 3
			bottomPadding: 3
			text: isFiltering ? "Found" : "Total"
			elide: Text.ElideRight
			Layout.fillWidth: true
			Layout.maximumWidth: implicitWidth
			color: _palette.color3

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true

				ToolTip.text: totalText.text
				ToolTip.visible: totalText.truncated && containsMouse
				ToolTip.delay: ControlsSettings.tooltipDelay
				ToolTip.timeout: ControlsSettings.tooltipTimeout
			}
		}

		Text {
			text: isFiltering
				? panelContext.numFilteredElements
				: panelContext.numElements
			color: _palette.color1
			rightPadding: ControlsSettings.padding * 2
		}

		Text {
			id: selectedText
			text: "Selected"
			elide: Text.ElideRight
			Layout.fillWidth: true
			Layout.maximumWidth: implicitWidth
			color: _palette.color3

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true

				ToolTip.text: selectedText.text
				ToolTip.visible: selectedText.truncated && containsMouse
				ToolTip.delay: ControlsSettings.tooltipDelay
				ToolTip.timeout: ControlsSettings.tooltipTimeout
			}

		}

		Text {
			text: viewContext.selectionModel.selectedIndexes.length
			color: _palette.color1
			rightPadding: ControlsSettings.padding * 2
		}

		Image {
			id: closedEyeIcon
			source: "image://gui/model_asset/close_eye"
			visible: panelContext.numHidden != 0

			ColorOverlay {
				anchors.fill: closedEyeIcon
				source: closedEyeIcon
				color: _palette.color3
			}

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true

				ToolTip.text: "Hidden count"
				ToolTip.visible: containsMouse
				ToolTip.delay: ControlsSettings.tooltipDelay
				ToolTip.timeout: ControlsSettings.tooltipTimeout
			}
		}

		Text {
			color: _palette.color1
			text: panelContext.numHidden
			visible: panelContext.numHidden != 0
			rightPadding: ControlsSettings.padding * 2
		}

		Image {
			id: lockedIcon
			source: "image://gui/freeze"
			visible: panelContext.numFrozen != 0

			ColorOverlay {
				anchors.fill: lockedIcon
				source: lockedIcon
				color: _palette.color3
			}

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true

				ToolTip.text: "Locked count"
				ToolTip.visible: containsMouse
				ToolTip.delay: ControlsSettings.tooltipDelay
				ToolTip.timeout: ControlsSettings.tooltipTimeout
			}
		}

		Text {
			color: _palette.color1
			text: panelContext.numFrozen
			visible: panelContext.numFrozen != 0
		}

		Item {
			Layout.fillWidth: true
		}
	}
}
