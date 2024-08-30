import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls.impl 1.0 as Impl

T.Menu {
	id: control

	Accessible.name: "Menu"
			
	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem ? contentItem.implicitWidth + leftPadding + rightPadding : 0)
	
	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding

	padding: ControlsSettings.radius
	overlap: 1

	enter: Details.PopupEnterTransition {}

	delegate: Controls.MenuItem {}
	contentItem: Details.MenuContent {}
	background: Details.MenuBackground {
		id: menuBackground
	}

	Component {
		id: separatorComponent
		MenuSeparator {}
	}

	Impl.PopupWindow.margins: menuBackground.shadowRadius

	onOpened: {
		updateNavigation();
	}

	function popupEx(modal) {
		Impl.PopupWindow.popup(modal)
	}


	function openEx() {
		Impl.PopupWindow.open()
	}

	function addSeparator() {
		addItem(separatorComponent.createObject(contentItem))
	}

	function calculateImplicitWidth() {
		var maxImplicitWidth = 0;
		var maxPadding = 0;
		for (var i = 0; i < count; ++i)
		{
			var item = itemAt(i);
			maxImplicitWidth = Math.max(maxImplicitWidth, item.implicitWidth);
			maxPadding = Math.max(maxPadding, item.padding);
		}
		return maxImplicitWidth + maxPadding * 2;
	}

	function updateNavigation()	{
		for (var i = 0; i < count; ++i) {
			var item = itemAt(i);
			item.KeyNavigation.up = findVisible(i, -1);
			item.KeyNavigation.down = findVisible(i, 1);
		}
	}

	function findVisible(index, delta)
	{
		index += delta;
		if (index < 0 || index >= count)
		{
			return null;
		}
		var item = itemAt(index);
		if (item.visible && item.type != Details.ControlsConstants.MenuItemType.Separator)
		{
			return item;
		}
		return findVisible(index, delta);
	}
}
