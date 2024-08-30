import QtQuick 2.7
import "Bars"
import "Sliders"

Item {
	Bars {
		id: bars
	}

	Sliders {
		visible: !bars.editing && !bars.animating
	}
}
