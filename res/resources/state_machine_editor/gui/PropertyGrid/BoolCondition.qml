import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

import Controls 1.0 as SMEControls

import "..//"

RowLayout {
	SMEControls.CheckBox {
		Layout.maximumHeight: 15
		Layout.maximumWidth: 15
		
		Binding on checked {
			value: styleData.condition ? styleData.condition.checked : false
		}

		onCheckedChanged: {
			if (styleData.condition)
				styleData.condition.checked = checked
		}
	}
}
