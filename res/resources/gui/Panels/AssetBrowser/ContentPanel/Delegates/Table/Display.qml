import QtQuick 2.7

Loader {
    signal sourceChanged()

	source: model
		? model.isDirectory
			? "DisplayFolder.qml"
			: "DisplayAsset.qml"
		: ""
}
