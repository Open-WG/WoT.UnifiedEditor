import QtQuick 2.10
import WGTools.Misc 1.0 as Misc

Row {
	spacing: 2

	Misc.Text {
		text: model.display + ":"
	}

	Misc.Text {
		color: _palette.color1
		text: model.value + (index != repeater.count - 1 ? ";" : "")
	}
}
