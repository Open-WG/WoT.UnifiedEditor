import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.ControlsEx 1.0
import WGTools.Controls.Details 2.0
import WGTools.PropertyGrid 1.0
import WGTools.Resources 1.0 as WGTResources
import "Details/ImagePreview" as Details

ImagePathDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	property var propertyRow
	property bool __enabled: propertyData && !propertyData.readonly // fix: WOTCC-11864

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null
	onPropertyDataChanged: control.reset()

	Details.PreviewPanel {
		id: control
		width: parent.width
		height: parent.height
		fileName: delegateRoot.imagePreviewPath
		Layout.fillWidth: true

		onPreviewDoubleClicked: {
			if (propertyData.value.length != 0) {
				context.openImageEditor(propertyData.value)
			}
		}

		onPreviewClicked: {
			if (delegateRoot.__enabled) {
				control.textField.dialogButton.openFileDialog()
			}
		}
	}

	CustomDropArea {
		parent: delegateRoot.propertyRow
		enabled: delegateRoot.__enabled
		target: control
		propertyData: delegateRoot.propertyData
	}
}
