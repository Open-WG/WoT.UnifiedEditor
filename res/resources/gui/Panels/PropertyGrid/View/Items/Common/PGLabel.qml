import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Misc 1.0 as Misc
import WGTools.Style 1.0
import "../../Settings.js" as Settings

Item {
	id: root

	property var selected
	property var horizontalAlignment: Text.AlignRight
	readonly property bool iconMode: model && model.node.label.icon.length > 0
	readonly property var text: model && model.node.label.text.length ? (model.node.label.text) : ""
	readonly property bool overridden: !!(model && model.node && model.node.overridden)
	property bool useGroupDepth: true

	implicitWidth: iconLabel.implicitWidth
	implicitHeight: iconLabel.implicitHeight

	Misc.IconLabel {
		id: iconLabel

		readonly property var colorScheme: [ _palette.color2 ]

		x: useGroupDepth ? Math.max(0, Settings.subTitleIndent * (styleData.group.depth - 1)) : 0
		y: (parent.height - height) / 2
		width: parent.width - x

		icon.visible: iconMode
		icon.source: iconMode ? ("image://gui/" + model.node.label.icon) : ""

		labelStyle: !overridden ? "text-base-label" : "text-base-label-overridden"

		label.visible: !iconMode
		label.elide: Text.ElideRight
		label.text: !overridden ? root.text : ("*" + root.text)
		label.horizontalAlignment: root.horizontalAlignment
		label.wrapMode: label.maximumLineCount != 1 ? Text.Wrap : Text.NoWrap
		label.maximumLineCount: parent.height != 0 && label.font.pixelSize != 0 ? parent.height / label.font.pixelSize : 1
		label.color: root.selected
			? _palette.color12
			: (model && model.node.property && model.node.property.dirty)
				? _palette.color1
				: _palette.color2

		Item {
			width: iconLabel.label.contentWidth
			height: iconLabel.label.contentHeight
			x: switch (iconLabel.label.horizontalAlignment) {
				case Text.AlignRight:   return (iconLabel.label.width - width)
				case Text.AlignHCenter: return (iconLabel.label.width - width) / 2
				default:                return 0
			}
			y: switch (iconLabel.label.verticalAlignment) {
				case Text.AlignBottom:  return (iconLabel.label.height - height)
				case Text.AlignVCenter: return (iconLabel.label.height - height) / 2
				default:                return 0
			}

			ToolTip.text: model ? model.node.label.tooltipText : ""
			ToolTip.delay: ControlsSettings.tooltipDelay
			ToolTip.timeout: ControlsSettings.tooltipTimeout
			ToolTip.visible: ToolTip.text && mouseArea.containsMouse
		}

		MouseArea {
			id: mouseArea
			width: parent.width
			height: parent.height
			acceptedButtons: Qt.NoButton
			hoverEnabled: true
		}
	}
}
