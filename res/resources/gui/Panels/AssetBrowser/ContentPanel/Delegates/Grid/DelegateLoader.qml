import QtQuick 2.7

Loader {
    signal sourceChanged()

	source: model.isDirectory ? "FolderDelegate.qml" : "AssetDelegate.qml"
}
