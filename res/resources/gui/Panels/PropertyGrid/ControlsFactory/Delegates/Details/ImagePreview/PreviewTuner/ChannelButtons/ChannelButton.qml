import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

MenuItem {
	id: control

	property string channelName

	text: channelName + " channel"
	checkable: true
	Accessible.name: text

	font.capitalization: Font.Capitalize
}
