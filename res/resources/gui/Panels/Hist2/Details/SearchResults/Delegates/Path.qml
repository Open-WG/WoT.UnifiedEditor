import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc

Control {
	hoverEnabled: true
	
	ToolTip.text: fileName.text
	ToolTip.visible: hovered && fileName.truncated

	contentItem: RowLayout {
		spacing: 8
		Layout.alignment: Qt.AlignLeft

		Image {
			source: getIconPath()
			smooth: true
			fillMode: Image.Pad

			function getIconPath() {
				if (!model) {
					return "";
				}

				var label = model.label;
				label = label.slice(label.lastIndexOf(".") + 1, label.length);
				switch (label) {
					case "model": return "image://system/debug_ui/item_icons/16x16/Model";
					case "dds":   return "image://system/debug_ui/item_icons/16x16/Decal";
					case "srt":   return "image://system/debug_ui/item_icons/16x16/Tree";
					default:      return "image://gui/code_icon";
				}
			}
		}

		Misc.Text {
			id: fileName
			text: model ? model.label : ""
			elide: styleData.elideMode
			color: _palette.color2
			verticalAlignment: Text.AlignVCenter
			Layout.fillWidth: true
		}
	}
}
