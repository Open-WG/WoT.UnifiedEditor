import QtQuick 2.11
import WGTools.Controls 2.0

MenuItem {
	text: model.display
	checkable: true

	onToggled: model.checkState = checked ? Qt.Checked : Qt.Unchecked
	Binding on checked {value: model.checkState == Qt.Checked}
}
