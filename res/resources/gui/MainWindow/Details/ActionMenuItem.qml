import WGTools.Controls 2.0
import WGTools.ControlsEx.Menu 1.0

MenuItem {
	property var source
	property bool valid: source && source.valid

	text: source ? source.text : ""
	visible: source && source.valid
	enabled: source && source.enabled
	checkable: source && source.checkable
	checked: source && source.checked

	onTriggered: source.execute()
}
