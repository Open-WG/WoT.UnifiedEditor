import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.PropertyGrid 1.0
import "Details/Color" as Details

ColorDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitHeight: layout.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readOnly

	function finalize() {
		colorEdit.closeColorDialog()
	}

	RowLayout {
		id: layout
		width: Math.min(implicitWidth, parent.width)

		Details.ColorEdit {
			id: colorEdit
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignVCenter
			Accessible.name: "Color"
		}

		Details.AlphaSpinBox {
			valueData: delegateRoot.alphaChannel
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignVCenter
			Accessible.name: "Alpha"
		}

		Details.LuminanceSpinBox {
			valueData: delegateRoot.luminanceChannel
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignVCenter
			Accessible.name: "Luminance"
		}
	}
}
