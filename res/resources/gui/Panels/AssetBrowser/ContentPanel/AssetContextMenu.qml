import QtQuick 2.11
import WGTools.Controls 2.0
import "Menu" as Details

Menu {
	id: menu
	modal: false

	signal tagsClicked()
	signal infoClicked()

	MenuItem {
		text: "Open"
		enabled: context.canOpenCurrentAsset(false)
		onClicked: Qt.callLater(function(){ context.openCurrentAsset(false, "") })
	}
	
	MenuItem {
		text: "Open in current tab"
		enabled: context.canOpenCurrentAsset(true)
		onClicked: Qt.callLater(function(){ context.openCurrentAsset(true, "") })
	}
	
	MenuItem {
		text: "Open in new app"
		enabled: context.canOpenCurrentAsset(false)
		onClicked: context.openCurrentAssetInNewApp()
	}

	OpenWithPresetMenu {
		title: "Open with settings"
		enabled: ["settings", "model", "srt", "fbx"].indexOf(context.currentAssetInfo.extension) >= 0
		isSpace: context.currentAssetInfo.extension == "settings"
	}

	Details.MenuItem {
		wgtAction: context.actions.menu.reveal_in_explorer
	}

	Details.MenuItem {
		wgtAction: context.actions.menu.system_menu
	}

	MenuSeparator {}

	Details.MenuItem {
		wgtAction: context.actions.menu.export_to_collada
	}

	Details.MenuItem {
		wgtAction: context.actions.menu.apply_terrain_material
	}

	MenuItem {
		text: context.tagsEditor.favorite ? "Remove from Favorites" : "Add to Favorites"
		icon.source: context.tagsEditor.favorite
			? "image://gui/icon-menu-favorite"
			: "image://gui/icon-menu-favorite-disabled"
		onClicked: context.tagsEditor.favorite = !context.tagsEditor.favorite
	}

	MenuItem {
		text: "Add Tags"
		icon.source: "image://gui/icon-menu-tags"
		onClicked: menu.tagsClicked()
	}

	MenuItem {
		text: "Show Info"
		onClicked: menu.infoClicked()
	}

	Details.MenuItem {
		wgtAction: context.actions.menu.copy_absolute_paths
	}

	Details.MenuItem {
		wgtAction: context.actions.menu.regenerate_thumbnails
	}
}
