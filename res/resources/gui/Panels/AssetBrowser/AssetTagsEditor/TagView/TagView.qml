import QtQuick 2.10
import WGTools.Controls 2.0
import "Delegates" as Delegates

Container {
	id: control

	property string tagFilter
	property bool canCreateTag: false
	property alias model: repeater.model

	readonly property Item newTagDelegate: Delegates.NewTagDelegate {
		width: parent ? parent.width : implicitWidth
		tagName: control.tagFilter
		highlighted: control.currentItem == newTagDelegate
		onClicked: control.newTagClicked(tagName)
	}

	signal tagClicked(string tag)
	signal newTagClicked(string tag)

	contentItem: TagViewContent {}

	onCurrentIndexChanged: {
		contentItem.positionViewAtIndex(currentIndex, ListView.Contain)
	}

	onTagFilterChanged: {
		currentIndex = control.count ? 0 : -1
	}

	onCanCreateTagChanged: {
		if (canCreateTag) {
			addItem(newTagDelegate)
		} else {
			takeItem(count - 1)
		}
	}

	Keys.forwardTo: contentItem
	Keys.onReturnPressed: currentItem ? currentItem.clicked() : undefined
	Keys.onEnterPressed: currentItem ? currentItem.clicked() : undefined
	Keys.onLeftPressed: {
		if (count && (event.modifiers & Qt.AltModifier)) {
			currentIndex = 0
		}
	}

	Keys.onRightPressed: {
		if (count && (event.modifiers & Qt.AltModifier)) {
			currentIndex = count - 1
		}
	}

	Repeater {
		id: repeater
		delegate: Delegates.TagDelegate {
			width: parent.width
			highlighted: index == control.currentIndex
			tagColor: model.decoration
			tagName: model.display
			matchPos: model.matchPos
			matchLen: model.matchLen
			onClicked: control.tagClicked(tagName)
		}
	}
}
