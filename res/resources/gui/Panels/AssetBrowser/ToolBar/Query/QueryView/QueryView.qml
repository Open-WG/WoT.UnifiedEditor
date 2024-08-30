import QtQuick 2.7

ListView {
	id: view

	property real horizontalIndents: 0

	signal clicked()
	signal pathClicked(string path)
	signal removeClicked(int index)

	clip: true
	boundsBehavior: Flickable.StopAtBounds
	orientation: ListView.Horizontal
	snapMode: ListView.SnapToItem

	header: Item { width: horizontalIndents }
	footer: header

	delegate: Loader {
		height: parent.height
		source: "Delegates/" + model.tokenType + ".qml"

		Connections {
			target: item
			ignoreUnknownSignals: true
			onSelected: view.pathClicked(selectedPath)	// path changed
			onCloseClicked: view.removeClicked(model.index)
		}
	}

	MouseArea {
		z: -1
		onClicked: view.clicked()
		anchors.fill: parent
	}
}
