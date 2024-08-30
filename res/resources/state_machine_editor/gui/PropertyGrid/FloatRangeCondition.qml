import QtQuick 2.7
import QtQuick.Layouts 1.3

import Controls 1.0 as SMEControls
import Condition 1.0

import "..//"

RowLayout {
	Layout.fillWidth: true

	SMEControls.ComboBox {
		Layout.preferredWidth: parent.width / 2

		currentIndex: styleData.condition.rangeOption

		model: [styleData.condition.getStringFromEnum(Condition.RANGE),
			styleData.condition.getStringFromEnum(Condition.LESS),
			styleData.condition.getStringFromEnum(Condition.GREATER)]

		onActivated: {
			if (displayText === styleData.condition.getStringFromEnum(Condition.RANGE))
				styleData.condition.rangeOption = Condition.RANGE
			else if (displayText === styleData.condition.getStringFromEnum(Condition.LESS))
				styleData.condition.rangeOption = Condition.LESS
			else
				styleData.condition.rangeOption = Condition.GREATER
		}
	}
	
	FloatSpinBox {
		Layout.fillWidth: true

		visible: styleData.condition.rangeOption != Condition.LESS

		Binding on value {
			value: styleData.condition ? styleData.condition.rangeStart : 0
		}

		onValueModified: {
			styleData.condition.rangeStart = value
		}
	}

	FloatSpinBox {
		Layout.fillWidth: true

		visible: styleData.condition.rangeOption != Condition.GREATER

		Binding on value {
			value: styleData.condition ? styleData.condition.rangeEnd : 0
		}

		onValueModified: {
			styleData.condition.rangeEnd = value
		}
	}
}
