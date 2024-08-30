import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.ControlsEx 1.0
import WGTools.PropertyGrid 1.0
import WGTools.Controls.impl 1.0
import "Details/Color" as Details

ColorDelegate {
	id: delegateRoot

	property var model // TODO: consider implement context property "model"
	property var propertyRow

	implicitHeight: layout.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	property bool __enabled: propertyData && !propertyData.readonly

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

	RawDropArea {
		id: dropArea
		parent: delegateRoot.propertyRow
		enabled: delegateRoot.__enabled
		anchors.fill: parent

		onDragEnter: {
			propertyData.dragEnter(event)
		}

		onDrop: {
			propertyData.drop(event)
		}

		DropIndicator {
			containsDrag: dropArea.containsDrag
			anchors.fill: parent
		}
	}
}
