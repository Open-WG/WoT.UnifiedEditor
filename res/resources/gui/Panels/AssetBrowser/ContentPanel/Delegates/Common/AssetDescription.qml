import QtQuick 2.7

Item {
	id: root

	property alias text: commonDescription.text
	property alias extension: assetExtention.extension
	property alias favorite: commonDescription.favorite

	property bool alignToVCenter: false
	property alias extensionVisible: assetExtention.visible
	readonly property real contentHeight: commonDescription.height + assetExtention.height + column.spacing

	implicitWidth: column.implicitWidth
	implicitHeight: column.implicitHeight

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
