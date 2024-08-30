import QtQuick 2.7

Loader {
	property string text

	signal sourceChanged()

	source: model.isDirectory ? "FolderDelegate.qml" : "AssetDelegate.qml"

	onLoaded: {
		if (item.text != undefined) {
			item.text = Qt.binding(function() { return text })
		}
	}
}
