import QtQuick 2.11

Flow {
	leftPadding: (control.indicator && control.indicator.visible) ? (control.indicator.width + control.spacing) : 0
	spacing: control.spacing
	clip: true

	Repeater {
		id: repeater
		model: control.delegateModel
	}
}
