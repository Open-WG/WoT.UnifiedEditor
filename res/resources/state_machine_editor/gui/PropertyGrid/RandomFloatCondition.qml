import QtQuick 2.7
import QtQuick.Layouts 1.3

import Controls 1.0 as SMEControls
import Condition 1.0

import "..//"

RowLayout {
	Layout.fillWidth: true
	
	FloatSpinBox {
		Layout.fillWidth: true

		Binding on value {
			value: styleData.condition ? styleData.condition.randomStart : 0
		}

		onValueModified: {
			styleData.condition.randomStart = value
		}
	}

	FloatSpinBox {
		Layout.fillWidth: true

		Binding on value {
			value: styleData.condition ? styleData.condition.randomEnd : 0
		}

		onValueModified: {
			styleData.condition.randomEnd = value
		}
	}
}
