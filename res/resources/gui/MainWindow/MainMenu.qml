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
		enabled: openFilmtrackId.valid

		Details.ActionMenuItem {
			id: openFilmtrackId
			source: context.action("openFilmtrackId")
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

		Menu {
			id: tlc
			title: "Top left corner"

			Details.ActionMenuItem {
				id: tlc_top_dock_area
				source: context.action("tlc_top_dock_area")
				checked: source.checked && !tlc_left_dock_area.checked
			}

			Details.ActionMenuItem {
				id: tlc_left_dock_area
				source: context.action("tlc_left_dock_area")
				checked: source.checked && !tlc_top_dock_area.checked
			}
		}

		Menu {
			id: trc
			title: "Top right corner"

			Details.ActionMenuItem {
				id: trc_top_dock_area
				source: context.action("trc_top_dock_area")
				checked: source.checked && !trc_right_dock_area.checked
			}

			Details.ActionMenuItem {
				id: trc_right_dock_area
				source: context.action("trc_right_dock_area")
				checked: source.checked && !trc_top_dock_area.checked
			}
		}

		Menu {
			id: blc
			title: "Bottom left corner"

			Details.ActionMenuItem {
				id: blc_bottom_dock_area
				source: context.action("blc_bottom_dock_area")
				checked: source.checked && !blc_left_dock_area.checked
			}

			Details.ActionMenuItem {
				id: blc_left_dock_area
				source: context.action("blc_left_dock_area")
				checked: source.checked && !blc_bottom_dock_area.checked
			}
		}

		Menu {
			id: brc
			title: "Bottom right corner"

			Details.ActionMenuItem {
				id: brc_bottom_dock_area
				source: context.action("brc_bottom_dock_area")
				checked: source.checked && !brc_right_dock_area.checked
			}

			Details.ActionMenuItem {
				id: brc_right_dock_area
				source: context.action("brc_right_dock_area")
				checked: source.checked && !brc_bottom_dock_area.checked
			}
		}

		MenuSeparator { }

		Details.ActionMenuItem {
			source: context.action("resetLayout")
		}

		Details.ActionMenuItem {
			source: context.action("saveLayout")
		}
	}

	MenuSeparator { }

	Menu {
		id: utilitiesMenu
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
		source: context.action("hotKeysDialogId")
	}

	Details.ActionMenuItem {
		source: context.action("settingsDialogId")
	}

	Menu {
		id: helpMenu
		title: "Help"

		Details.ActionMenuItem {
			source: context.action("getHelp")
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
