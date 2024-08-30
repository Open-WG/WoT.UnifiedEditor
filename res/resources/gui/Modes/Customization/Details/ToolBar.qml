import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls.Details 2.0
import WGTools.Controls.impl 1.0 as Impl
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as WGT

RowLayout {
	id: toolbar

	property var textFilter
	property var toolBarActions
	property var placeholderText

	WGT.SearchField {
		Layout.fillWidth: true

		placeholderText: parent.placeholderText

		onTriggered: toolbar.textFilter.text = text
		Binding on text {value: toolbar.textFilter ? toolbar.textFilter.text : ""}
	}

	Repeater {
		model: toolBarActions

		Controls.Button {
			flat: true

			action: Impl.ActionAdapter {
				action: model.action.action
				sourceScheme: "image://gui/"
			}

			Controls.ToolTip.text: text
			Controls.ToolTip.delay: ControlsSettings.tooltipDelay
			Controls.ToolTip.timeout: ControlsSettings.tooltipTimeout
			Controls.ToolTip.visible: hovered && Controls.ToolTip.text.length
		}
	}
}
