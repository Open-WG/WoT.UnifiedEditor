import QtQuick 2.7
import WGTools.Controls 2.0

CheckBox {
	property var valueData

	Accessible.name: text == null ? "Checkbox" : text

	onReleased: {
		valueData.setValue(checked)
	}

	Binding on tristate {
		value: checkState == Qt.PartiallyChecked
	}

	Binding on checkState {
		value: Qt.Checked
		when: valueData != undefined && valueData.value == true
	}

	Binding on checkState {
		value: Qt.Unchecked
		when: valueData != undefined && valueData.value == false
	}

	Binding on checkState {
		value: Qt.PartiallyChecked
		when: valueData == undefined || valueData.value == undefined
	}
}
