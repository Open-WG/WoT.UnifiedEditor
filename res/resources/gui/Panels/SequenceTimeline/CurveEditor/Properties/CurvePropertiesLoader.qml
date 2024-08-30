import QtQuick 2.11

Loader {
	active: visible
	source: "CurveProperties.qml"

	Accessible.name: "Curve Properties"

	property QtObject styleData: QtObject {
		readonly property var proxy: itemData.decomposedValues
		readonly property var context: rootSequenceTree.rootContext
	}
}
