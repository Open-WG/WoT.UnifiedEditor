import QtQuick 2.11
import QtQuick.Layouts 1.4
import "../Buttons"

RowLayout {
	property var treeAdapter: null
	property var curveActions: null

	spacing: 12

	RecordButton {}

	RowLayout {
		spacing: 1

		PlaybackFirstFrameButton {}
		PlaybackPrevFrameButton {}
		PlaybackPlayButton {}
		PlaybackNextFrameButton {}
		PlaybackLastFrameButton {}
		PlaybackStopButton {}
	}

	Item { Layout.fillWidth: true }

	RowLayout {
		spacing: 1
		visible: context.sequenceOpened && context.curveMode

		BaseTangentButton { actionId: "smoothTangent" }
		BaseTangentButton { actionId: "linearTangent" }
		BaseTangentButton { actionId: "steppedTangent" }
		BaseTangentButton { actionId: "freeTangent" }
		BaseTangentButton { actionId: "brokenTangent" }
	}

	Item { Layout.fillWidth: true }
	
	TimelineLimits {}
	HelpButton {}
}
