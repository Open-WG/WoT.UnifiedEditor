import QtQuick 2.11

Rectangle {
	readonly property bool hasData: model && model.rect != undefined

	visible: hasData && model.visibility
	x: hasData ? model.rect.x : 0
	y: hasData ? model.rect.y : 0
	width: hasData ? model.rect.width : 0
	height: hasData ? model.rect.height : 0
}
