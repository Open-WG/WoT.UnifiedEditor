import QtQuick 2.7
import Controls 1.0 as SMEControls

SMEControls.CheckBox {
	Binding on checked {
		value: styleData.item.value
	}

	onCheckedChanged: {
		styleData.item.value = checked
	}
}
