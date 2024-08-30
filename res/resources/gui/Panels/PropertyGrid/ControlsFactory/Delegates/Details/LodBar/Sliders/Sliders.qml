import QtQuick 2.7

Item {
	id: container
	width: parent.width
	height: parent.height

	Repeater {
		id: repeater
		model: lodbar.model

		LodSlider {
			width: parent.width
			height: parent.height
			z: (hovered || pressed) ? repeater.count : index

			fullRange: lodbar.range
			from: model.lod.extentLimitsStart
			to: model.lod.extentLimitsEnd

			onModified: {
				model.lod.setExtent(value, !commit, modifiers & Qt.ShiftModifier)
			}

			Binding on value {
				value: Math.min(model.lod.extentEnd, lodbar.range)
			}
		}
	}
}
