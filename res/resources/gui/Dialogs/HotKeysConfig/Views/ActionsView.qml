import QtQuick 2.11
import WGTools.Controls 2.0
import "Details/ActionsView" as Details

Pane {
	id: pane

	property alias model: view.model

	ListView {
		id: view
		width: pane.availableWidth
		height: pane.availableHeight

		activeFocusOnTab: true
		clip: true
		boundsBehavior: Flickable.StopAtBounds

		delegate: Details.Delegate {}
		ScrollBar.vertical: ScrollBar {}

		onCountChanged: {
			if (count == 0)
				currentIndex = -1
			else
				currentIndex = Math.max(0, Math.min(currentIndex, count - 1))
		}
	}
}
