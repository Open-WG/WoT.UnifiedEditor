import QtQuick 2.11

Item {
	id: scaleItem

	property alias model: repeater.model

	Repeater {
		id: repeater

		delegate: CurveScaleStroke {
			width: parent.width
			y: scaleItem.height - Math.round(model.position)
			text: model.value.toFixed(3)
		}
	}
}
