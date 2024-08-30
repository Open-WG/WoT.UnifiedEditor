import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx

ControlsEx.Panel {
	id: spacePresets
	
	title: "Presets"
	layoutHint: "bottom"
	property var margins: 10
	property var orientation: Qt.Horizontal

	RowLayout {
		id: chapterSwitcherLayout
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: parent.margins

		Controls.Button {
			icon.source: orientation == Qt.Horizontal
				? "image://gui/icon-horizontal-layout"
				: "image://gui/icon-vertical-layout"

			onClicked: {
				orientation = (orientation == Qt.Horizontal) ? Qt.Vertical : Qt.Horizontal
			}
		}

		Repeater {
			model: context.chapterListModel

			Controls.RadioButton {
				text: model.chapterName
				checked: context.currentChapter === index
				onToggled: context.currentChapter = index
			}
		}

		Item {
			// spacer item
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}

	Repeater {
		id: chapterViews
		model: context.chapterListModel
		PresetChapterView {
			anchors.top: chapterSwitcherLayout.bottom
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.margins: parent.margins
			visible: context.currentChapter === index
			viewContext: model.chapterContext
			orientation: spacePresets.orientation
		}
	}
}