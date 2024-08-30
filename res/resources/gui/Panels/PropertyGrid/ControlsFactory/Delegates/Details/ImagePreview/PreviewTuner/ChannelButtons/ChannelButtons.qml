import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import "../../Preview"

Repeater {
	id: root

	property int channelCount: 0
	property PreviewSettings settings

	model: ListModel {
		ListElement {text: "red"; icon: "image://gui/texture_asset/r-channel"}
		ListElement {text: "green"; icon: "image://gui/texture_asset/g-channel"}
		ListElement {text: "blue"; icon: "image://gui/texture_asset/b-channel"}
		ListElement {text: "alpha"; icon: "image://gui/texture_asset/alpha-channel"}
	}

	ChannelButton {
		channelName: model.text
		enabled: root.settings && index < root.channelCount
		checkable: !checked || root.settings.enabledChannels > 1
		icon.source: model.icon

		Layout.fillWidth: true
		Layout.maximumWidth: implicitWidth

		Binding on checked {
			value: root.settings && root.settings[model.text];
		}

		onToggled: {
			root.settings[model.text] = checked
		}
	}
}
