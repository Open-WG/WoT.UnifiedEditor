import QtQuick 2.10
import WGtools.Controls 2.0

ItemDelegate {
	id: control

	property color tagColor
	property string tagName: ""
	property int matchPos: 0
	property int matchLen: 0

	text: matchLen
		? tagName.substr(0, matchPos)
			+ "<b><u>"
			+ tagName.substr(matchPos, matchLen)
			+ "</u></b>"
			+ tagName.substr(matchPos + matchLen)
		: tagName

	leftPadding: padding + indicator.width + spacing
	indicator: TagDelegateIndicator {}
	contentItem: TagDelegateContent {}
}
