import QtQuick 2.7

Item {
	id: root

	property alias text: commonDescription.text
	property alias favorite: commonDescription.favorite
	property alias childrenCount: folderChildrenCount.value

	property bool alignToVCenter: false
	property alias childrenCountVisible: folderChildrenCount.visible
	readonly property real contentHeight: commonDescription.height + folderChildrenCount.height + column.spacing

	implicitWidth: column.implicitWidth
	implicitHeight: column.implicitHeight

	Column {
		id: column
		width: parent.width

		anchors.verticalCenter: root.alignToVCenter ? root.verticalCenter : undefined

		CommonDescription {
			id: commonDescription
			width: parent.width
		}

		FolderChildrenCount {
			id: folderChildrenCount
		}
	}
}
