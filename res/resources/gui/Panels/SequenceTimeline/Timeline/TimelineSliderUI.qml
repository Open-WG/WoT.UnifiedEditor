import QtQuick 2.11
import QtQuick.Controls 2.0

RangeSlider {
	id: control

	readonly property bool moving: ma.drag.active

	signal moved(real newFirstPosition, real newSecondPosition)

	labels.visible: false

	Binding { target: contentItem.sliderRange; property: "color"; value: _palette.color3 }

	Binding { target: contentItem.groove; property: "color"; value: _palette.color5 }
	Binding { target: contentItem.groove; property: "implicitHeight"; value: 10 }

	Binding { target: first.handle; property: "y"; value: first.handle.height / 2 }
	Binding { target: first.handle.contentItem; property: "__strokeColor"; value: _palette.color1 }
	Binding { target: first.handle.contentItem; property: "__fillColor"; value: _palette.color1 }

	Binding { target: second.handle; property: "y"; value: first.handle.height / 2 }
	Binding { target: second.handle.contentItem; property: "__strokeColor"; value: _palette.color1 }
	Binding { target: second.handle.contentItem; property: "__fillColor"; value: _palette.color1 }

	MouseArea {
		id: ma
		parent: control.contentItem.groove
		z: control.contentItem.sliderRange.z + 1

		Binding on width { value: control.contentItem.sliderRange.width; when: !ma.drag.active }
		Binding on height { value: control.contentItem.sliderRange.height; when: !ma.drag.active }
		Binding on x { value: control.contentItem.sliderRange.x; when: !ma.drag.active }
		Binding on y { value: control.contentItem.sliderRange.y; when: !ma.drag.active }

		drag.target: ma
		drag.threshold: 0
		drag.axis: orientation == Qt.Horizontal ? Drag.XAxis : Drag.YAxis
		drag.minimumX: 0
		drag.maximumX: control.contentItem.groove.width - control.contentItem.sliderRange.width
		drag.minimumY: 0
		drag.maximumY: control.contentItem.groove.height - control.contentItem.sliderRange.height

		Connections {
			enabled: ma.drag.active
			onXChanged: {
				var newFirstPosition = ma.x / control.contentItem.groove.width
				var newSecondPosition = (ma.x + ma.width) / control.contentItem.groove.width

				control.moved(newFirstPosition, newSecondPosition)
			}
		}
	}
}
