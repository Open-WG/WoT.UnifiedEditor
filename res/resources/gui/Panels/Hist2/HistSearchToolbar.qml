import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls

ColumnLayout {
	spacing: 7

	Controls.Button {
		Layout.fillWidth: true
		text: "Edit Algorithms"
		onClicked: context.showAlgorithmEditorDialog()
	}

	Controls.Button {
		Layout.fillWidth: true
		text: "Assign Algorithms"
		onClicked: context.showManageAlgorithmDialog()
	}
}
