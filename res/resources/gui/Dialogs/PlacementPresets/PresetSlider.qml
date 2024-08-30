import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Controllers 1.0 as Controllers

RowLayout {
	id: root

	property alias label: lowSpin.label
	property real lowVal
	property real highVal
	property real lowLimit: -100
	property real highLimit: 100

	signal lowModified(real val)
	signal highModified(real val)
	
	Controls.DoubleSpinBox {
		id: lowSpin
		objectName: "low"
		Accessible.name: objectName

		editable: context.editable
		from: root.lowLimit
		to: root.highVal
		
		Binding on value {
			value: root.lowVal
		}

		onValueModified: lowModified(value)
	}

	Controls.RangeSlider {
		id: slider
		Accessible.name: "Slider"

		Layout.fillWidth: true
		
		enabled: context.editable
		from: root.lowLimit
		to: root.highLimit

		Binding {
			target: slider.second
			property: "value"
			value: root.highVal
		}

		Binding {
			target: slider.first
			property: "value"
			value: root.lowVal
		}

		Controllers.RangeSliderController {
			onFirstModified: lowModified(slider.first.value)
			onSecondModified: highModified(slider.second.value)
		}
	}

	Controls.DoubleSpinBox {
		objectName: "high"
		editable: context.editable
		Accessible.name: objectName
		
		Binding on value {
			value: root.highVal
		}

		from: root.lowVal
		to: root.highLimit

		onValueModified: highModified(value)
	}
}
