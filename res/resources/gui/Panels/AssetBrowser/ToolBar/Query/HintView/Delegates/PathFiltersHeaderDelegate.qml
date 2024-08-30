import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Item {
	id: root

	property string path: ""
	property string filters: ""
	
	Misc.IconLabel {
		anchors.fill: parent

		icon.source: "image://gui/icon-magnifier?color=" + encodeURIComponent(_palette.color2)
		iconNest.width: 30

		label.textFormat: Text.StyledText
		label.text: {
			var pathText = root.path.length > 0 ? root.path : "Home"
			var txt = 'Go to "<b>' + pathText + '</b>"'

			if (root.filters.length > 0)
			{
				if (txt.length > 0)
				{
					txt += ' and '
				}

				txt += 'Search for "<b>' + root.filters + '</b>"'
			}

			return txt
		}
	}
}
