import QtQuick 2.11
import WGTools.Controls 2.0

ItemDelegate {
	property bool selected: control.currentIndex == index

	width: parent.width
	implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
	highlighted: control.highlightedIndex == index && control.highlightEnabled
	hoverEnabled: control.hoverEnabled
	text: {
		if (control.textRole == "")
			return modelData

		if (Array.isArray(control.model))
			return modelData[control.textRole]

		return model[control.textRole]
	}

	icon.source: selected ? "image://gui/icon-check" : ""
}
