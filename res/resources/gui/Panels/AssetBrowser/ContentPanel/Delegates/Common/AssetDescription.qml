import QtQuick 2.7

Item {
	id: root

	property string text: ""
	property alias extension: assetExtention.extension
	property alias favorite: commonDescription.favorite

	property bool alignToVCenter: false
	property alias extensionVisible: assetExtention.visible
	readonly property real contentHeight: commonDescription.height + assetExtention.height + column.spacing

	implicitWidth: column.implicitWidth
	implicitHeight: column.implicitHeight

	onTextChanged: {
		var fullExtension = "." + root.extension
		var modifiedText = text
		if (root.text.includes(fullExtension) && root.extensionVisible) {
			var extensionRegex = "\\" + fullExtension + "$"
			console.log(extensionRegex)
			modifiedText = root.text.replace(new RegExp(extensionRegex, 'i'), "")
		}
		commonDescription.text = modifiedText
	}

	Column {
		id: column
		width: parent.width

		anchors.verticalCenter: alignToVCenter ? parent.verticalCenter : undefined

		CommonDescription {
			id: commonDescription
			width: parent.width
		}
		
		AssetExtention {
			id: assetExtention
			width: Math.min(implicitWidth, parent.width)
		}
	}
}
