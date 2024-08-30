import QtQml.Models 2.2
import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.Misc 1.0 as Misc
import "../ContentPanel/Delegates/Common" as ConentPanelCommon
import "../ContentPanel/Delegates/Table" as ConentPanelTable
import WGT.ImagePreview 1.0 as WGTImagePreview
import WGTools.Controls 2.0
import WGTools.Styles.Text 1.0 as Text

Rectangle {
	id: root

	property var assetInfo
	property bool blockContentResizing: false
	property real minPreviewWidth: 128
	property real minPropertiesWidth: 100
	property real previewRelativeWidth: 0.5

	color: _palette.color7
	clip: true

	QtObject {
		id: p

		readonly property bool isValid: assetInfo !== null
		readonly property bool isFolder: getAssetData("isFolder")

		function getAssetData(role, defaultValue) {

			if (isValid && typeof assetInfo[role] != "undefined")
				return assetInfo[role]

			if (typeof defaultValue == "undefined")
				defaultValue = ""

			return defaultValue
		}
	}

	// content item
	Flickable {
		id: flickableItem
		visible: p.isValid

		flickDeceleration: 0
		contentHeight: {
			if (state == "vertical"){
				return preview.height + spacing + propertiesColumn.height;
			}
			else{
				return Math.max(preview.height, propertiesColumn.height);
			}
		}

		ScrollBar.vertical: ScrollBar {}

		readonly property real spacing: 20
		readonly property real targetPreviewWidth: Math.max(root.minPreviewWidth, width * root.previewRelativeWidth)
		readonly property real targetPropertiesWidth: width - targetPreviewWidth - spacing

		anchors.fill: root.blockContentResizing ? undefined : parent
		anchors.margins: 10

		states:	State {
			name: "vertical"
			when: root.minPropertiesWidth > flickableItem.targetPropertiesWidth

			PropertyChanges {
				target: propertiesColumn

				anchors.top: preview.bottom
				anchors.topMargin: flickableItem.spacing
				anchors.left: propertiesColumn.parent.left
				anchors.leftMargin: undefined
			}

			PropertyChanges {
				target: preview
				width: Math.max(parent.width, root.minPreviewWidth)
			}

		}

		transitions: Transition {
			NumberAnimation {
				target: preview
				property: "width"
				duration: 100
			}
		}

        Connections {
            target: root.assetInfo
            onAssetNameChanged: preview.reload()
        }

		// Asset Preview
		ConentPanelCommon.AssetIcon {
			id: preview
			height: implicitHeight
			width: flickableItem.targetPreviewWidth
			source: p.isValid
				? p.isFolder
					? "image://gui/preview-folder"
					: "image://thumbnail/" + p.getAssetData("fullName")
				: ""

			anchors.top: parent.top
			anchors.left: parent.left
		}

		// Properties Column
		Column {
			id: propertiesColumn

			readonly property real minWidth: 100

			width: parent.width - x
			spacing: 7

			anchors.top: parent.top
			anchors.left: preview.right
			anchors.leftMargin: flickableItem.spacing

			Column {
				width: parent.width

				Text.H1 {
					width: parent.width
					text: p.getAssetData("assetName")
				}

				ConentPanelCommon.FolderChildrenCount {
					visible: p.isFolder
					value: visible ? p.getAssetData("itemCount") : 0
				}

				ConentPanelCommon.AssetExtention {
					height: 12
					visible: !p.isFolder
					extension: visible ? p.getAssetData("extension") : ""
				}
			}

			ModificationInfo {
				width: parent.width
				title: "Last modified"
				date: p.getAssetData("modifiedDate")
				author: p.getAssetData("modifiedAuthor")
			}

			ModificationInfo {
				width: parent.width
				title: "Created"
				date: p.getAssetData("createdDate")
				author: p.getAssetData("createdAuthor")
			}

			InfoRow {
				width: parent.width
				visible: p.isValid && !p.isFolder
				title: "Size"
				text: getSize(p.getAssetData("size"))

				function getSize(byteCount){

					var suffixes = ["B", "KB", "MB", "GB", "TB"];
					var currentSuffix = 0;
					var size = byteCount;

					while (size > 1024 && currentSuffix < suffixes.length){
						currentSuffix++;
						size /= 1024;
					}

					if (currentSuffix == 0){
						return size + " " + suffixes[currentSuffix];
					}

					return size.toFixed(3) + " " + suffixes[currentSuffix];
				}
			}

			//for textures
			WGTImagePreview.FlatImageInfoModel{
				id: imageInfo
				fileName: p.getAssetData("fullName")
			}

			InfoRow {
				width: parent.width
				visible: imageInfo.valid
				title: "Resolution"
				text: imageInfo.width + "x" + imageInfo.height
			}

			InfoRow {
				width: parent.width
				visible: imageInfo.valid
				title: "Compression"
				text: imageInfo.compression
			}

			InfoRow {
				width: parent.width
				visible: imageInfo.valid
				title: "Format"
				text: imageInfo.format
			}

			InfoRow {
				width: parent.width
				visible: imageInfo.valid
				title: "MipCount"
				text: imageInfo.mipCount
			}

			ConentPanelTable.Tags {
				width: parent.width

				property QtObject styleData: QtObject {
					readonly property var value: p.getAssetData("tags")
				}
			}
		}
	}
}
