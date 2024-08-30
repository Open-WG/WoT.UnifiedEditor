import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Controls.Controllers 1.0
import WGTools.Utils 1.0
import WGTools.PropertyGrid 1.0 as PG

Slider {
	id: slider

	property var valueData
	property alias controller: controller

	wheelEnabled: activeFocus && propertyGrid.controlsWheelEnabled
	snapMode: Slider.SnapAlways
	minSoft: valueData != undefined ? valueData.valueMinSoftOriginal : undefined
	maxSoft: valueData != undefined ? valueData.valueMaxSoftOriginal : undefined

	ticks.visible: stepSize > 0
	labels.visible: true

	Accessible.name: "Slider"

	Keys.forwardTo: controller

	Binding {
		target: handle
		property: "visible"
		value: valueData != undefined && valueData.value != undefined
	}

	Binding {
		target: slider.labels
		property: "decimals"
		when: valueData != undefined;
		value: valueData != undefined ? valueData.valuePrecision : 0
	}

	Binding on stepSize {
		when: valueData != undefined;
		value: valueData != undefined ? valueData.valueStep * controller.stepMultiplier : 0
	}

	Binding on from {
		when: valueData != undefined;
		value: valueData != undefined ? valueData.valueMinSoft : undefined
	}

	Binding on to {
		when: valueData != undefined;
		value: valueData != undefined ? valueData.valueMaxSoft : undefined
	}

	Binding on value {
		when: slider.handle.visible && !slider.pressed
		value: slider.handle.visible ? valueData.value : slider.value
	}

	SliderController {
		id: controller
		step: valueData != undefined ? valueData.valueStep : 0
		decimals: slider.labels.decimals
		onModified: valueData.setValue(
			Utils.roundValue(slider.value, slider.labels.decimals),
			!commit ? PG.IValueData.TRANSIENT : 0
		)
	}
}
