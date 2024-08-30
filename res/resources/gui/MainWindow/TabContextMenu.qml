import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.ControlsEx.Menu 1.0
import "./Details" as Details

Menu {
	id: mainMenu
	property var index: -1
	property var model: null

	Details.ActionMenuItem {
		source: context.model.action("revealInAssetBrowser", index)
	}

	MenuSeparator {
		width: parent.width
	}

	MenuItem {
		text: "Save as..."
		onTriggered: context.saveAs(index)
		visible: model != undefined && model.hasSaveAs
		enabled: model != undefined && model.isLoaded
	}

	MenuItem {
		text: "Reload"
		onTriggered: context.reloadAsset(index)
	}

	Details.ActionMenuItem {
		source: context.model.action("reload_all_textures_action", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("autosetMatKinds", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("exportToDae", index)
	}

	MenuSeparator {
		width: parent.width
	}

	MenuItem {
		text: "Close"
		onTriggered: context.closeTabByIndex(index)
	}

	MenuItem {
		text: "Close all tabs"
		onTriggered: context.closeAllTabs()
	}

	MenuItem {
		text: "Close all but this"
		onTriggered: context.closeAllButIndex(index)
	}

	MenuSeparator {
		width: parent.width
		height:
			replaceWithAction.visible || filmEditorSettingsAction.visible
			? implicitHeight
			: 0
	}

	Details.ActionMenuItem {
		id: replaceWithAction
		source: context.model.action("replace_with_action", index)
	}

	Details.ActionMenuItem {
		id: duplicateItemsAction
		source: context.model.action("duplicate_items_action", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("save_selection_as_group_action")
	}

	Details.ActionMenuItem {
		source: context.model.action("restore_group_position_action")
	}

	Details.ActionMenuItem {
		source: context.model.action("spaceeditor_collada_export_sellection", index)
	}

	MenuSeparator {
		width: parent.width
		height: lockSpace.visible ? implicitHeight : 0
	}

	Details.ActionMenuItem {
		id: lockSpace
		source: context.model.action("lockSpace", index)
	}

	Details.ActionMenuItem {
		id: filmEditorSettingsAction
		source: context.model.action("filmEditorSettingsId", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("spaceeditor_editspaceid", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("gameplaySettings", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("activate_frontline_mode_action", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("spaceSettingsActionId", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("environmentSettingsActionId", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("shGridSettingsActionId", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("terrainSettingsActionId", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("spaceeditor_processAllDataid", index)
	}

	MenuSeparator {
		width: parent.width
		height: regenerateGlobalAmAction.visible ? implicitHeight : 0
	}

	Details.ActionMenuItem {
		id: regenerateGlobalAmAction
		source: context.model.action("regenerate_global_am_action", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("regenerate_decals_bin", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("regenerate_road_bin_action", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("regenerate_all_road_bins_action", index)
	}

	MenuSeparator {
		width: parent.width
		height: convertTilesTextureAction.visible ? implicitHeight : 0
	}

	Details.ActionMenuItem {
		id: convertTilesTextureAction
		source: context.model.action("convert_tiles_texture_action", index)
	}

	Details.ActionMenuItem {
		source: context.model.action("convert_speedtree_texture_action", index)
	}

	onAboutToHide: {
		context.onHideMenu(index)
	}

	onAboutToShow: {
		implicitWidth = calculateImplicitWidth()
		context.onShowMenu(index)
	}

}
