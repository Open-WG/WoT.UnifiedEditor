import QtQuick 2.11

QtObject {
	property var data

	readonly property bool available: data && data.node.gridMember && !data.node.label.visible
	readonly property string text: available ? data.node.label.text : ""
}
