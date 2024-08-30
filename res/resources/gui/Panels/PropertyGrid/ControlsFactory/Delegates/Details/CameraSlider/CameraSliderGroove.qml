import QtQuick 2.7
import WGTools.Misc 1.0 as Misc
import "../../Settings.js" as Settings

Rectangle {
	id: root
	implicitWidth: 100
	implicitHeight: Settings.cameraSliderGrooveHeight
	color: "#303030"

	Row {
		id: container
		width: parent.width
		height: parent.height

		Repeater {
			id: repeater
			model: control.model

			Rectangle {
				width: parent.width * (control.to ? Math.max(0, (model.lod.actualExtentEnd - model.lod.actualExtentStart)) / control.to : 0)
				height: parent.height
				color: (model != undefined) ? _palette[model.lod.name] : "#FFF"
			}
		}
	}
}
