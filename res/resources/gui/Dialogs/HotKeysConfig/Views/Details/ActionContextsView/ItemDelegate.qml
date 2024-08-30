import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.impl 1.0
import WGTools.Clickomatic 1.0 as Clickomatic

ItemDelegate {
	id: delegate
	text: styleData.value
	enabled: false

	leftPadding: 0
	background: null

	icon.source: model ? "image://gui/context/" + model.display : ""
	icon.color: "transparent"

	ActiveFocus.when: styleData.index == view.currentIndex
	Binding {target: delegate.contentItem; property: "opacity"; value: 1}

	// clickomatic --------------------------------
	Accessible.name: accesibleNameGenerator.value
	Clickomatic.TableAccesibleNameGenerator {
		id: accesibleNameGenerator
		role: view.accesibleNameRole
		modelIndex: styleData.index
	}
	// --------------------------------------------
}
