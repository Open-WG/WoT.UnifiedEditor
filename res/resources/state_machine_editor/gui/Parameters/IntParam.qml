import QtQuick 2.7

import "..//"

FloatSpinBox {
	decimals: 0
	
	validator: IntValidator {
		
	}

	Binding on value {
		value: styleData.item.value
	}

	onValueModified: {
		styleData.item.value = value
	}
}