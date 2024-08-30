import QtQuick 2.7
import WGTools.Controls.Details 2.0 as Details

Details.SpinBoxBackground {
	property alias preview: colorPreviewLayer.preview
	
	implicitWidth: 80

	ColorPreviewLayer {
		id: colorPreviewLayer
		width: parent.width
		height: parent.height

		preview.color: control.visible && control.valueData.value != undefined
			? Qt.rgba(1, 1, 1, control.valueData.value / 100)
			: undefined
	}
}
