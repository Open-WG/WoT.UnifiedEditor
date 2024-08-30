import QtQuick 2.11
import WGTools.Utils 1.0

QtObject {
	property bool visible: true
	property int decimals: 2
	property var textFromValue: function(value, locale, decimals) {
		return Utils.textFromValue(value, locale, decimals)
	}
}