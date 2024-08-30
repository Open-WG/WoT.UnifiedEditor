import QtQuick 2.7
import "../Common" as Common

Common.DelegateTemplate {
	id: root
	Accessible.name: desc.text + "/"

	readonly property string assetPath: model ? model.fullName : ""

	padding: 2
	spacing: 10
	orientation: Qt.Horizontal

	icon: Common.FolderIcon {}
	desc: Common.FolderDescription {
		text: model ? model.display : ""
		favorite: model ? model.isFavorite : false
		childrenCount: model ? model.childrenCount : 0

		alignToVCenter: true
		childrenCountVisible: root.availableHeight >= contentHeight
	}
}
