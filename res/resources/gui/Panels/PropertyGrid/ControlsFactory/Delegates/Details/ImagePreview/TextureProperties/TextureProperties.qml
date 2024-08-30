import QtQuick 2.10
import WGTools.Controls.Details 2.0
import WGT.ImagePreview 1.0 as WGTImagePreview

Flow {
	property alias fileName: imageInfoModel.fileName
	padding: ControlsSettings.doublePadding
	spacing: 2

	Repeater {
		id: repeater
		model: WGTImagePreview.ImageInfoModel { id: imageInfoModel }
		PropertyItem {}
	}
}