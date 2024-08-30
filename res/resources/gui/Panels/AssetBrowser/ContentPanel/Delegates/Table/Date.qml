import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Item {
	Misc.Text {
		id: text

		property int formatIndex: 0
		property var formats: [
			{showTime: true, format: Qt.SystemLocaleLongDate},
			{showTime: true, format: Qt.SystemLocaleShortDate, maxWidth: 150},
			{showTime: false, format: Qt.SystemLocaleShortDate, maxWidth: 100}
		]

		anchors { verticalCenter: parent.verticalCenter; left: parent.left; right: parent.right }
		anchors.margins: 10

		elide: styleData.elideMode
		color: _palette.color2
		horizontalAlignment: styleData.textAlignment
		
		text: {
			if (styleData.value === undefined)
				return "???"

			var formatData = formats[formatIndex]
			return formatData.showTime ? Qt.formatDateTime(styleData.value, formatData.format) : Qt.formatDate(styleData.value, formatData.format)
		}

		onWidthChanged: {
			for (var i = formats.length-1; i>=0; --i)
			{
				if (formats[i].maxWidth == undefined || width < formats[i].maxWidth)
				{
					text.formatIndex = i;
					break;
				}
			}
		}
	}
}
