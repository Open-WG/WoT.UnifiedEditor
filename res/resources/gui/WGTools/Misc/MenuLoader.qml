import QtQuick 2.11

Loader {
	id: loader

	property alias menuComponent: loader.sourceComponent

	active: false
	onLoaded: item.popupEx()

	function popup() {
		loader.active = true
	}

	Connections {
		target: loader.item
		onClosed: loader.active = false
	}
}
