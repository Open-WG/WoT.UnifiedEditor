import QtQuick 2.7
import "../Common" as Common

Common.DelegateTemplate {
	readonly property string assetPath: model ? model.fullName : ""

	padding: 5
	spacing: 5

	Accessible.name: model.display

    Connections {
        target: parent
        onSourceChanged: icon.reload()
    }

	icon: Common.AssetIcon {
		source: model ? "image://thumbnail/" + model.fullName : ""
	}
	desc: Common.AssetDescription {
		text: model.display
		favorite: model.isFavorite
		extension: model.extension
	}
	background: DelegateBackground {}
}
