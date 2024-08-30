import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import "..//Buttons"
import "..//Constants.js" as Constants
import "..//Controls" as SEControls
import "..//Debug"

SEControls.Dialog {
	id: dialog

	property alias value: spinBox.value
	property alias autoSplitVal: autoSplitCheckBox.checked
	property real curveLength: 0

	modal: true

	title: "Normalize Position Track (Experimental)"

	standardButtons: Dialog.Ok | Dialog.Cancel

	contentItem: RowLayout {
		spacing: 0

		ColumnLayout {
			Text {
				id: lengthLabel

				padding: 3
				text: "Curve Length:"

				verticalAlignment: Text.AlignVCenter

				font.family: Constants.proximaRg
				font.bold: true
				font.pixelSize: 12
				color: Constants.fontColor
			}

			Text {
				id: spinBoxLabel

				padding: 3
				text: "New Time:"

				verticalAlignment: Text.AlignVCenter

				font.family: Constants.proximaRg
				font.bold: true
				font.pixelSize: 12
				color: Constants.fontColor
			}

			Text {
				id: autoSplitLabel

				padding: 3
				text: "Auto-Split:"

				verticalAlignment: Text.AlignVCenter

				font.family: Constants.proximaRg
				font.bold: true
				font.pixelSize: 12
				color: Constants.fontColor
			}
		}

		ColumnLayout {
			Text {
				text: dialog.curveLength.toFixed(2)

				verticalAlignment: Text.AlignVCenter

				font.family: Constants.proximaRg
				font.bold: true
				font.pixelSize: 12
				color: Constants.fontColor
			}

			SEControls.DoubleSpinBox {
				id: spinBox

				Layout.preferredHeight: spinBoxLabel.height
				Layout.fillWidth: true
			}

			SEControls.CheckBox {
				id: autoSplitCheckBox

				checked: false

				Layout.preferredHeight: autoSplitLabel.height
			}
		}
	}
}
