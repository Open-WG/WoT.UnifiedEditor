import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc

import "Details/NormalizedPlayback" as Details
import "Settings.js" as Settings

NormalizedPlaybackDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readonly

	RowLayout {
		id: layout
		width: parent.width

		Button {
			id: playPauseButton

			icon.source: delegateRoot.playing
				? "image://gui/fbx_asset/pause"
				: "image://gui/fbx_asset/play"

			onClicked: {
				delegateRoot.playing = !delegateRoot.playing
			}
		}

		Button {
			id: restartButton

			icon.source: "image://gui/fbx_asset/restart"

			onClicked: delegateRoot.restart()
		}

		Details.NormalizedPlaybackTimeline {
			Layout.fillWidth: true
		}
	}
}
