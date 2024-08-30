import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.impl 1.0

ItemDelegate {
	id: delegate
	text: styleData.value
	enabled: false

	leftPadding: 0
	background: null

	icon.source: model ? "image://gui/context/" + model.display : ""
	icon.color: "transparent"

	Binding on ActiveFocus.when {
		value: styleData.index == view.currentIndex
		delayed: true
	}
 
	Binding {target: delegate.contentItem; property: "opacity"; value: 1}
}
