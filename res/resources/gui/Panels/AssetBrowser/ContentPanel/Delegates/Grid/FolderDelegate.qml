import QtQuick 2.7
import "../Common" as Common

Common.DelegateTemplate {
	readonly property string assetPath: model && model.hasOwnProperty("fullName") ? model.fullName : ""

	Accessible.name: model.display

	padding: 5
	spacing: 5

	icon: Common.FolderIcon {}
	desc: Common.FolderDescription {
		text: model.display
		favorite: model.isFavorite
		childrenCount: model.childrenCount
	}
	background: DelegateBackground {}
}
