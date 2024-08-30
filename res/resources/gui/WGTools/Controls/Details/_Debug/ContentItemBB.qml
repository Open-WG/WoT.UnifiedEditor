import QtQuick 2.11
import WGTools.Controls.Details 2.0

ControlBB {
	z: 101
	a: control.contentItem ? control.contentItem : parent
	sp: !control.contentItem
	c: "blue"
}
