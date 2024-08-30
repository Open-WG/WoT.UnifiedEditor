import QtQuick 2.7
import WGTools.Controls.Details 2.0 as Details

Details.TextFieldBackground {
	property alias preview: cpl.preview

	ColorPreviewLayer {
		id: cpl
		width: parent.width
		height: parent.height

		preview.width: 34
		preview.color: delegateRoot.colorPreview
	}
}
