import QtQuick 2.11
import QtQuick.Layouts 1.0
import WGTools.Controls 2.0

TimelineToolButton {
	id: control

	property string actionId

	action: curveActions ? curveActions.action(actionId) : null
	enabled: action && action.enabled
	iconImage: action ? action.icon.name : ""

	Layout.preferredWidth: 36
}
