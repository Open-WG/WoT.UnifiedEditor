import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.impl 1.0 as Impl
import "./Details" as Details

Menu {
	id: menu

	onAboutToShow: {
		implicitWidth = calculateImplicitWidth()
	}

	Menu {
		id: newMenu
		title: "New"
		enabled: createAtlasDialogId.valid
			|| modifySpaceDialogId.valid
			|| createStateMachineID.valid
			|| createFilmtrackID.valid
			|| createTankID.valid

		Details.ActionMenuItem {
			id: createAtlasDialogId
			source: context.action("createAtlasDialogId")
		}

		Details.ActionMenuItem {
			id: modifySpaceDialogId
			source: context.action("modifySpaceDialogId")
		}

		Details.ActionMenuItem {
			id: createStateMachineID
			source: context.action("createStateMachineID")
		}

		Details.ActionMenuItem {
			id: createFilmtrackID
			source: context.action("createFilmtrackID")
		}

		Details.ActionMenuItem {
			id: createTankID
			source: context.action("createTankID")
		}
	}

	Menu {
		id: openMenu
		title: "Open"
		enabled: openFilmtrackId.valid || openReplayId.valid

		Details.ActionMenuItem {
			id: openFilmtrackId
			source: context.action("openFilmtrackId")
		}

		Details.ActionMenuItem {
			id: openReplayId
			source: context.action("openReplayId")
		}
	}

	Menu {
		id: recentsMenu
		title: "Recent"

		Instantiator {
			model: context.recentsModel
			onObjectAdded: recentsMenu.insertItem(index, object)
			onObjectRemoved: recentsMenu.removeItem(object)

			MenuItem{
				text: model.text
				onTriggered: Qt.callLater(function() { context.openAsset(model.text) })
			}
		}

		onAboutToShow: {
			context.recentsModel.updateData();
			implicitWidth = calculateImplicitWidth();
		}
	}

	Menu {
		id: windowsMenu
		title: "Window"

		Instantiator {
			model: context.windowsModel
			onObjectAdded: windowsMenu.insertItem(index, object)
			onObjectRemoved: windowsMenu.removeItem(object)

			MenuItem {
				text: model.action.text
				checkable: model.action.checkable
				checked: model.action.checked
				onTriggered: model.action.execute()
			}
		}

		MenuSeparator { }

		Details.ActionMenuItem {
			source: context.action("saveLayout")
		}

		Details.ActionMenuItem {
			source: context.action("restoreLayout")
		}
	}

	MenuSeparator { }

	Menu {
		id: toolsMenu
		title: "Tools"

		Menu {
			id: spaceToolsMenu
			title: "Space tools"

			onAboutToShow: {
				implicitWidth = calculateImplicitWidth()
			}

			Details.ActionMenuItem {
				source: context.action("moctDialogId")
				visible: !context.isLite
			}

			Details.ActionMenuItem {
				source: context.action("mapsValidatorDialogId")
				visible: !context.isLite
			}

			MenuSeparator {
				visible: !context.isLite
			}

			Details.ActionMenuItem {
				source: context.action("regenerateDecalsBinInAllSpaces")
			}
		}

		Details.ActionMenuItem {
			source: context.action("tankAssetsProcessorId")
			visible: !context.isLite
		}
	}

	Details.ActionMenuItem {
		source: context.action("hotKeysDialogId")
	}

	Details.ActionMenuItem {
		source: context.action("settingsDialogId")
	}

	Menu {
		id: helpMenu
		title: "Help"

		Details.ActionMenuItem {
			source: context.action("ueHome")
			visible: !context.isLite
		}

		Details.ActionMenuItem {
			source: context.action("ueDoc")
			visible: !context.isLite
		}

		Details.ActionMenuItem {
			source: context.action("releaseNotes")
			visible: !context.isLite
		}

		MenuSeparator {
			visible: !context.isLite
		}

		Details.ActionMenuItem {
			source: context.action("aboutDialogId")
		}
	}

	MenuSeparator {
		visible: !context.isLite
	}

	Menu {
		id: developersMenu
		title: "For developers"

		Component.onCompleted: parent.visible = !context.isLite

		Details.ActionMenuItem {
			source: context.action("reloadQMLActionId")
		}

		Details.ActionMenuItem {
			source: context.action("showDynamicPluginsPanel")
		}

		Menu {
			id: crash
			title: "Crash"

			Details.ActionMenuItem {
				source: context.action("crashAssertActionId")
			}

			Details.ActionMenuItem {
				source: context.action("crashCriticalExceptionActionId")
			}

			Details.ActionMenuItem {
				source: context.action("crashDereferenceNullptrActionId")
			}

			Details.ActionMenuItem {
				source: context.action("crashHangActionId")
			}
		}
	}

	MenuSeparator { }

	Details.ActionMenuItem {
		source: context.action("closeApplication")
	}
}
