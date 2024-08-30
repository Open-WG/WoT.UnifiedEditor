import QtQuick 2.11
import "../Common" as Common

Common.DelegateTemplate {
	readonly property string assetPath: model ? model.fullName : ""
	property alias text: assetDescription.text

	padding: 5
	spacing: 5

	Accessible.name: text

	Connections {
		target: parent
		onSourceChanged: icon.reload()
	}

	icon: Common.AssetIcon {
		source: model ? "image://thumbnail/" + model.fullName : ""
	}
	desc: Common.AssetDescription {
		id: assetDescription
		favorite: model.isFavorite
		extension: model.extension
	}
	background: DelegateBackground {}
}
