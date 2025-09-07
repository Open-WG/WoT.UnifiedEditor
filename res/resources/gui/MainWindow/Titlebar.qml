import QtQuick 2.10
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Misc 1.0 as Misc
import WGTools.Utils 1.0
import "Settings.js" as Settings

ColumnLayout {
	spacing: 0

	Rectangle {
		Layout.fillWidth: true
		Layout.fillHeight: true
		implicitHeight: Settings.titlebarHeight
		color: _palette.color9

		Accessible.name: "Titlebar"

		TabContextMenu {
			id: contextMenu
		}

		Item {
			height: parent.height
			anchors.left: parent.left
			anchors.right: prefixText.left

			DropdownButton {
				id: menuButton
				width: ControlsSettings.toolBarSize
				menu: MainMenu {
					y: parent.height
				}

				icon.source: Qt.application.state == Qt.ApplicationActive
					? "image://gui/unifiededitor_16x16"
					: "image://gui/icon-system-menu-disabled"

				icon.width: 16
				icon.height: 16

				anchors.left: parent.left
				anchors.top: parent.top
				anchors.bottom: parent.bottom

				Accessible.name: "Logo"
				ToolTip.text: Qt.application.name
				ToolTip.visible: menuButton.hovered
				ToolTip.delay: ControlsSettings.tooltipDelay
				ToolTip.timeout: ControlsSettings.tooltipTimeout
			}

			Tabbar {
				id: tabs
				model: context.model
				width: Utils.clamp(parent.width - x - Settings.titlebarDragSpace, Settings.minimumTabWidth, implicitWidth)
				height: parent.height
				anchors.left: menuButton.right

				Binding on currentIndex {
					value: context.model.activateTabIndex
				}

				delegate: Tab {
					height: parent.height
					width: Math.min(Settings.tabWidth, tabs.implicitWidth / tabs.count)

					onActivatePressed: {
						context.model.activateTab(index)
					}

					onCloseClicked: {
						context.model.closeTab(index)
					}

					onContextMenuClicked: {
						contextMenu.index = index
						contextMenu.model = model
						contextMenu.popupEx()
					}
				}

				menuDelegate: MenuItem {
					text: model.display
					checkable: true
					Binding on checked { value: model.active }

					onTriggered: {
						context.model.activateTab(index)
						checked = model.active
					}
				}
			}

			Item {
				id: captionArea
				height: parent.height
				anchors.left: tabs.right
				anchors.right: parent.right

				property int hitTest: 2 // HTCAPTION
			}
		}

		Button {
			id: submitBugButton
			anchors {
				right: prefixText.left
				top: parent.top
				bottom: parent.bottom
				rightMargin: 10
			}

			icon.source: "image://gui/submit_bug_icon"
			icon.color: "transparent"

			icon.width: 20
			icon.height: 20

			hoverEnabled: true
			flat: true

			Rectangle {
				anchors.fill: parent
				z: -1
				color: parent.hovered
					? _palette.color6
					: "transparent"
			}

			onClicked: Qt.openUrlExternally("https://confluence.wargaming.net/x/GHGIfQ")

			ToolTip.text: "Submit a Bug"
			ToolTip.visible: hovered
			ToolTip.delay: ControlsSettings.tooltipDelay
			ToolTip.timeout: ControlsSettings.tooltipTimeout
		}

		Button {
			anchors {
				right: submitBugButton.left
				top: parent.top
				bottom: parent.bottom
				rightMargin: 10
			}

			icon.source: context.isEventEnabled ? "image://gui/" + context.eventIcon("event_on") : "image://gui/" + context.eventIcon("event_off")
			icon.color: "transparent"

			icon.width: 20
			icon.height: 20

			hoverEnabled: true
			flat: true
			visible: context.isEventTime

			Rectangle {
				anchors.fill: parent
				z: -1
				color: parent.hovered
					? _palette.color6
					: "transparent"
			}

			onClicked: context.setEventEnabled(!context.isEventEnabled)

			ToolTip.text: context.isEventEnabled ? "Switch event off" : "Switch event on"
			ToolTip.visible: hovered
			ToolTip.delay: ControlsSettings.tooltipDelay
			ToolTip.timeout: ControlsSettings.tooltipTimeout
		}

		Misc.Text {
			id: prefixText
			text: context.currentPrefix
			anchors.right: realmButton.left
			anchors.verticalCenter: parent.verticalCenter
			anchors.rightMargin: 10
			font.bold: true
		}
		
		DropdownButton {
			id: realmButton
			Accessible.name: "Realm Button"
			buttonBackgroundColor: _palette.color9
			width: realmText.implicitWidth + Settings.realmButtonWidthAddition
			enabled: !context.realmFrozen
			
			menu: Menu {
				id: realmMenu
				y: parent.height

				Repeater {
					id: realmMenuRepeater
					model: context.realmKeys

					delegate: MenuItem {
						text: modelData

						onTriggered: {
							context.requestChangeRealm(index);
						}
					}
				}
			
			}

			Misc.Text {
				id: realmText
				text: "Current realm: " + context.currentRealm
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter
			}

			anchors.right: sysMenu.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.rightMargin: Settings.realmButtonMargin
		}

		Row {
			id: sysMenu
			height: parent.height
			anchors.right: parent.right

			WindowButton {
				id: minButton
				Accessible.name: "Minimize"
				source: "image://gui/icon-sys-minimize?color=" + encodeURIComponent(_palette.color2)
				onClicked: _mainWindow.showMinimized()
			}

			WindowButton {
				id: maxButton
				Accessible.name: "Maximize"
				source: (typeof _mainWindowHandle !== 'undefined' && _mainWindowHandle.visibility === Window.Windowed
					? "image://gui/icon-sys-maximize?color="
					: "image://gui/icon-sys-restore?color=") + encodeURIComponent(_palette.color2)

				onClicked: {
					if (_mainWindow.maximized) {
						_mainWindow.showNormal()
					} else {
						_mainWindow.showMaximized()
					}
				}
			}

			WindowButton {
				id: closeButton
				Accessible.name: "Close"
				source: "image://gui/icon-sys-close?color=" + encodeURIComponent(_palette.color2)
				onClicked: _mainWindow.close()
			}
		}
	}

	Rectangle {
		Layout.fillWidth: true
		implicitHeight: Settings.titlebarSeparatorHeight
		color: (context.model.activateTabIndex > -1) ? _palette.color8 : _palette.color9
	}

	Rectangle {
		Layout.fillWidth: true
		implicitHeight: Settings.titlebarSeparatorHeight
		color: _palette.color9
	}
}
