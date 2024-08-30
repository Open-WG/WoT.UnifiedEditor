import QtQuick 2.7
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import "Query" as Query

Pane {
	id: toolbar

	property alias previewSize: menu.previewSize

	property alias prevButton: prevButton
	property alias nextButton: nextButton
	property alias refreshButton: refreshButton
	property alias queryEdit: queryEdit
	property alias favoriteButton: favoriteButton
	property alias tagsButton: tagsButton
	property alias infoButton: infoButton
	property alias menuButton: menuButton
	property alias menu: menu

	contentWidth: layout.implicitWidth
	contentHeight: layout.implicitHeight

	Accessible.name: "Toolbar"

	Binding {
		target: toolbar.background
		property: "color"
		value: _palette.color8
	}

	RowLayout {
		id: layout
		spacing: ControlsSettings.spacing

		anchors.fill: parent

		ToolBarButton {
			id: prevButton
			icon.source: "image://gui/icon-back"

			Accessible.name: "Previous"
			ToolTip.text: "Navigate Backward"
		}

		ToolBarButton {
			id: nextButton
			icon.source: "image://gui/icon-forward"

			Accessible.name: "Next"
			Layout.leftMargin: -layout.spacing
			ToolTip.text: "Navigate Forward"
		}
			
		ToolBarButton {
			id: layoutButton
			icon.source: menu.contentView && menu.contentView.orientation == Qt.Horizontal
				? "image://gui/icon-horizontal-layout"
				: "image://gui/icon-vertical-layout"

			Accessible.name: "Layout"
			Layout.leftMargin: -layout.spacing
			ToolTip.text: "Toggle Orientation"

			onClicked: {
				menu.contentView.orientation = (menu.contentView.orientation == Qt.Horizontal) ? Qt.Vertical : Qt.Horizontal
			}
		}

		ToolBarButton {
			id: refreshButton
			icon.source: "image://gui/icon-refresh"

			Accessible.name: "Refresh"
			Layout.leftMargin: -layout.spacing
			ToolTip.text: "Refresh Filesystem"
		}

		Query.QueryEdit {
			id: queryEdit
			activeFocusOnTab: true
			color: "transparent"

			Accessible.name: "Search"
			Layout.alignment: Qt.AlignVCenter
			Layout.fillWidth: true
			Layout.minimumWidth: 100
		}

		ToolBarButton {
			id: favoriteButton
			checkable: true
			icon.source: checked
				? "image://gui/icon-favorite"
				: "image://gui/icon-favorite-disabled"

			Accessible.name: "Favorite"
			ToolTip.text: checked ? "Remove From Favorite" : "Add to Favorite"
		}

		ToolBarButton {
			id: tagsButton 
			checkable: true
			icon.source: "image://gui/icon-tags"

			Accessible.name: "Tags"
			ToolTip.text: "Show Tags Menu"
		}

		ToolBarButton {
			id: infoButton
			checkable: true
			icon.source: "image://gui/icon-info"

			Accessible.name: "Info"
			ToolTip.text: checked ? "Hide Properties" : "Show Properties"
		}

		ToolBarButton {
			id: menuButton
			checked: menu.visible
			icon.source: "image://gui/icon-menu"

			Accessible.name: "Menu button"
			ToolTip.text: checked ? "Hide Preferences" : "Show Preferences"

			onPressed: menu.openEx()

			ToolBarMenu {
				id: menu
				x: parent.width - width
				y: parent.height
			}
		}
	}
}
