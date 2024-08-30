import QtQuick 2.7
import "../Common" as Common

Common.DelegateTemplate {
	id: root

	Accessible.name: desc.text

	readonly property string assetPath: model ? model.fullName : ""

    Connections {
        target: parent
        onSourceChanged: icon.reload()
    }

	padding: 2
	spacing: 10
	orientation: Qt.Horizontal

	icon: Common.AssetIcon {
		source: model ? "image://thumbnail/" + model.fullName : ""
	}
	desc: Common.AssetDescription {
		text: model ? model.display : ""
		favorite: model ? model.isFavorite : 0
		extension: model ? model.extension : ""

		alignToVCenter: true
		extensionVisible: root.availableHeight >= contentHeight
	}
}
