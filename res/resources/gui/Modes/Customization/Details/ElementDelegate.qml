import QtQuick 2.11
import QtQml.Models 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Models 1.0

Button {
	id: control

	signal rightClicked()

	hoverEnabled: true
	contentItem: ElementDelegateContent {}
	background: ElementDelegateBackground {}

	ToolTip.text: model.namePreview ? model.namePreview : model.texture
	ToolTip.visible: hovered && ToolTip.text.length
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout

	ListElementSelection {
		id: elementSelection
		row: index
		selectionModel: control.GridView.view.selection
	}
}
