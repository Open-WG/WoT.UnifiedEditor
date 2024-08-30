import QtQuick 2.11
import WGTools.Controls 2.0

Button {
	text: model[control.textRole]
	checkable: true

	onToggled: {
		control.setSelected(index, checked)
		checked = model.checkState == Qt.Checked
	}

	Binding on checked {
		value: model.checkState == Qt.Checked
	}
}
