import QtQuick 2.7
import WGTools.Misc 1.0 as Misc
import "../../../Settings.js" as Settings

Item {
	width: parent.width
	height: parent.height
	enabled: focus

	Misc.Text {
		id: label
		width: Math.min(parent.width, contentWidth)
		text: typeof model != "undefined"
			? model.lod.infinite
				? Settings.lodInfinityText
				: model.lod.extentEnd.toFixed(model.lod.decimals) + " " + Settings.lodExtentUnits
			: ""

		anchors.verticalCenter: parent.verticalCenter
	}

	Misc.InteractiveUnderline {
		shown: control.hovered
		buddy: label
		delay: Settings.interactionAnimDelay
		duration: Settings.interactionAnimDuration
	}
}
