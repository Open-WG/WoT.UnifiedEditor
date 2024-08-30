import QtQuick 2.10
import WGTools.Controls 2.0

ItemDelegate {
	id: control

	property string tagName

	text: 'Create "<b>' + tagName + '</b>"'
	indicator: NewTagDelegateIndicator {}
}
