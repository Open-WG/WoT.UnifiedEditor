import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.Clickomatic 1.0 as Clickomatic
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Utils 1.0
import "Settings.js" as LocalSettings

RowLayout {
	id: layout
	spacing: 0

	property alias model: tabsView.model
	property alias delegate: tabsView.delegate
	property alias menuDelegate: menuInstantiator.delegate

	property alias currentIndex: tabsView.currentIndex
	readonly property alias count: tabsView.count

	DropdownButton {
		visible: menuInstantiator.count > 0
		Accessible.name: "AllEditors"
		Layout.fillHeight: true

		icon.source: "image://gui/opened-tabs"
		menu: Menu {
			id: menu

			Instantiator {
				id: menuInstantiator
				model: tabsView.model
				onObjectAdded: menu.insertItem(index, object)
				onObjectRemoved: menu.removeItem(object)
			}

			onAboutToShow: {
				implicitWidth = calculateImplicitWidth();
			}
		}
	}

	ListView {
		id: tabsView
		Accessible.name: "Tabs"
		implicitWidth: Utils.clamp(layout.parent.width, LocalSettings.minimumTabWidth * count, LocalSettings.tabWidth * count)
		implicitHeight: contentHeight
		orientation: ListView.Horizontal
		boundsBehavior: Flickable.StopAtBounds
		clip: true

		Layout.fillWidth: true
		Layout.fillHeight: true

		onCurrentIndexChanged: {
			positionTimer.start()
		}

		Clickomatic.ClickomaticItem.showChild: function(childName) {
			var index = model.findChild(childName);
			tabsView.positionViewAtIndex(index, ListView.Contain);
		}

		Timer {
			id: positionTimer
			interval: LocalSettings.tabAnimDuration
			repeat: false
			onTriggered: {
				tabsView.positionViewAtIndex(model.activateTabIndex, ListView.Contain)
			}
		}

		add: Transition {
			NumberAnimation { property: "y"; from: tabsView.height; duration: LocalSettings.tabAnimDuration; easing.type: Easing.OutQuad }
		}

		remove: Transition {
			NumberAnimation { property: "y"; to: tabsView.height; duration: LocalSettings.tabAnimDuration; easing.type: Easing.OutQuad }
		}

		displaced: Transition {
			NumberAnimation { property: "x"; duration: LocalSettings.tabAnimDuration; easing.type: Easing.OutQuad }
		}

		MouseArea {
			acceptedButtons: Qt.NoButton;
			anchors.fill: parent

			onWheel: {
				let delta = Math.round((wheel.angleDelta.y == 0 ? wheel.angleDelta.x : wheel.angleDelta.y) / 120)
				let nextContentX = tabsView.contentX - (ControlsSettings.mouseWheelScrollVelocity2 * delta)
				let widthDif = tabsView.contentWidth - tabsView.width
				tabsView.contentX = (tabsView.originX < widthDif)
					? Utils.clamp(nextContentX, tabsView.originX, tabsView.originX + widthDif)
					: tabsView.originX
			}
		}
	}
}
