import QtQuick 2.7

import "..//"

FloatSpinBox {
	validator: IntValidator {
		
	}

	Binding on value {
		value: styleData.item.value
	}

	onValueModified: {
		styleData.item.value = value
	}
}