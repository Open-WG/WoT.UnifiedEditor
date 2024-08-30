import QtQuick 2.11
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0

Item {
	readonly property alias iconVisible: icon.visible

	implicitWidth: 16
	implicitHeight: 16

	Item {
		id: icon
		width: parent.width
		height: parent.height
		visible: {
			if (model == null)
				return false
			
			if (!model.showOnlyOnHover)
				return true

			if (model.checked)
				return true

			return (root.itemModel != undefined && typeof root.itemModel["hoverRole"] != "undefined") ? root.itemModel.hoverRole : false
		}

		Loader {
			id: loaderItem
			source: "ButtonDelegates/" + model.iconType + ".qml"
			anchors.fill: parent
			Accessible.name: model.decoration ? model.decoration.split('/').pop() : iconColour
		}

		ColorOverlay {
			anchors.fill: loaderItem
			source: loaderItem
			color: model != null ? model.iconColour : "transparent"
			Accessible.ignored: true
		}

		MouseArea {
			anchors.fill: parent
			Accessible.ignored: true

			onClicked: {
				let shiftPressed = (mouse.modifiers & Qt.ShiftModifier) == Qt.ShiftModifier
				let ctrlPressed = (mouse.modifiers & Qt.ControlModifier) == Qt.ControlModifier
				
				model.action.invoke(sceneBrowserContext.assetSelection, shiftPressed && ctrlPressed);
			}
		}

		// TODO: display by HoverHandler from Qt 5.12
		// Controls.ToolTip.text: model.tooltip
		// Controls.ToolTip.visible: model.tooltip.length > 0 && root.model.hoverRole
		// Controls.ToolTip.delay: 500
		// Controls.ToolTip.timeout: 1000
	}
}
