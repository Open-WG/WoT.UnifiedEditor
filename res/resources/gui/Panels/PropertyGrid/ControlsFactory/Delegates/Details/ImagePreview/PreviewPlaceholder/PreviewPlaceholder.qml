import QtQuick 2.10
import WGT.ImagePreview 1.0
import "../Preview"
import WGTools.Controls.Details 2.0
import WGTools.States 1.0 as States

Rectangle {
	property int status: SimpleImageModel.Empty

	implicitWidth: ControlsSettings.toolButtonWidth
	implicitHeight: implicitWidth
	color: "transparent"

	Component {
		id: empty
		States.StateEmpty {}
	}

	Component {
		id: loading
		States.StateLoading {}
	}

	Component {
		id: error
		States.StateError {}
	}

	Component {
		id: undefinedComp
		States.StateUndefined {}
	}

	Component {
		id: nullComp
		Item {}
	}

	Loader {
		anchors.centerIn: parent
		width: parent.width - ControlsSettings.smallPadding
		height: width
		sourceComponent: {
			switch (parent.status)
			{
			case SimpleImageModel.Empty:
				return empty
			case SimpleImageModel.Loading:
				return loading
			case SimpleImageModel.Error:
				return error
			case SimpleImageModel.Undefined:
				return undefinedComp
			default:
				return nullComp
			}
		}
	}

	PreviewFrame {
		anchors.fill: parent
	}
}
