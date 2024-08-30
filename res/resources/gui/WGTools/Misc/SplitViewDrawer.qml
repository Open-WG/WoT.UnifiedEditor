import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.11
import WGTools.Controls.Details 2.0

Item {
	id: drawer

	property SplitView view
	property alias hideable: visibilityBinding.when

	property real size
	property real implicitSize: vertical ? implicitHeight : implicitWidth
	property real padding: 0

	readonly property bool vertical: view && view.orientation == Qt.Vertical
	readonly property bool resizing: view && view.resizing
	readonly property alias running: trans.running

	readonly property bool opened: state == "opened"
	readonly property bool closed: state == "closed"

	Binding on Layout.minimumWidth {value: !vertical && drawer.resizing ? padding : -1}
	Binding on Layout.maximumWidth {value: !vertical && drawer.resizing ? parent.width - drawer.padding : -1}
	Binding on Layout.minimumHeight {value: vertical && drawer.resizing ? padding : -1}
	Binding on Layout.maximumHeight {value: vertical && drawer.resizing ? parent.height - drawer.padding : -1}

	onSizeChanged: {
		if (resizing) {
			implicitSize = size
		}
	}

	onWidthChanged: {
		if (resizing && !vertical) {
			size = width
		}
	}

	onHeightChanged: {
		if (resizing && vertical) {
			size = height
		}
	}

	onVerticalChanged: {
		if (vertical) {
			var relSize = implicitSize / parent.width
			implicitSize = Math.min(Math.max(padding, relSize * parent.height), parent.height - padding)

			if (opened) {
				relSize = size / parent.width
				size = Math.min(Math.max(padding, relSize * parent.height), parent.height - padding)

				height = size
			}

			return
		}

		if (!vertical) {
			var relSize = implicitSize / parent.height
			implicitSize = Math.min(Math.max(padding, relSize * parent.width), parent.width - padding)

			if (opened) {
				relSize = size / parent.height
				size = Math.min(Math.max(padding, relSize * parent.width), parent.width - padding)

				width = size
			}

			return
		}
	}

	Binding on width {when: !drawer.vertical && !drawer.resizing; value: size; delayed: true}
	Binding on height {when: drawer.vertical && !drawer.resizing; value: size; delayed: true}

	Binding on visible {
		id: visibilityBinding
		value: state == "opened" || size != padding
	}

	function toggle() {
		state = (state == "closed") ? "opened" : "closed"
	}

	function close() {
		state = "closed"
	}

	function open() {
		state = "opened"
	}

	state: "opened"
	states: [
		State {
			name: "closed"
			PropertyChanges {target: drawer; size: drawer.padding; restoreEntryValues: false}
		},

		State {
			name: "opened"
			PropertyChanges {
				target: drawer
				size: drawer.implicitSize
				restoreEntryValues: false
				explicit: true
			}
		}
	]

	Component.onCompleted: trans.enabled = true
	transitions: Transition {
		id: trans
		enabled: false
		NumberAnimation { properties: "size"; easing.type: Easing.InOutQuad; duration: ControlsSettings.effectDuration }
	}

	// HAND DRIVEN open
	Connections {
		enabled: drawer.state == "closed" && drawer.resizing && !drawer.vertical
		onWidthChanged: {
			trans.enabled = false
			drawer.state = "opened"
			trans.enabled = true
		}
	}

	Connections {
		enabled: drawer.state == "closed" && drawer.resizing && drawer.vertical
		onHeightChanged: {
			trans.enabled = false
			drawer.state = "opened"
			trans.enabled = true
		}
	}
}
