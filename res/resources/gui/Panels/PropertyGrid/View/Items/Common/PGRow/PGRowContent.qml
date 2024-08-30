import QtQuick 2.11
import "../../../Settings.js" as Settings

Item {
	readonly property bool useGridLabelWidth: control.gridMember && control.label && control.label.iconMode

	implicitWidth: controlContainer.implicitWidth + (control.splitter.visible ? labelContainer.implicitWidth + control.splitter.width : 0)
	implicitHeight: controlContainer.implicitHeight + (!control.horizontal && labelContainer.visible ? labelContainer.implicitHeight + control.splitter.width : 0)

	Item {
		id: labelContainer
		implicitWidth: control.label ? control.label.implicitWidth : 0
		implicitHeight: control.label ? control.label.implicitHeight : 0
		width: control.horizontal
			? useGridLabelWidth
				? Settings.gridLabelWidth - control.leftPadding
				: control.splitter.x - control.leftPadding
			: parent.width

		height: control.horizontal ? parent.height : implicitHeight
		visible: control.label && control.label.enabled

		Binding { target: control.label; property: "parent"; value: labelContainer }
		Binding { target: control.label; property: "width"; value: labelContainer.width; delayed: true }
		Binding { target: control.label; property: "height"; value: labelContainer.height }
	}

	Item {
		id: controlContainer
		implicitWidth: control.item ? control.item.implicitWidth : 0
		implicitHeight: control.item ? control.item.implicitHeight : 0
		width: control.splitter.visible
			? useGridLabelWidth
				? control.width - Settings.gridLabelWidth - control.rightPadding
				: (control.width - control.splitter.x - control.splitter.width - control.rightPadding)
			: parent.width

		height: (control.horizontal || !labelContainer.visible) ? parent.height : parent.height - labelContainer.height
		x: parent.width - width
		y: parent.height - height

		Binding { target: control.item; property: "parent"; value: controlContainer }
		Binding { target: control.item; property: "width"; value: controlContainer.width; delayed: true }
		Binding { target: control.item; property: "height"; value: controlContainer.height }
	}
}
