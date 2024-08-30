import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Item {
	property bool wrapEnabled: true
	property real spacing: 3
	property alias text: description.text
	property alias favorite: favoritesIndicator.value

	implicitWidth: description.implicitWidth + (favoritesIndicator.value ? favoritesIndicator.implicitWidth + spacing : 0)
	implicitHeight: description.implicitHeight
	baselineOffset: description.baselineOffset

	FavoritesIndicator {
		id: favoritesIndicator
		y: (description.height/description.lineCount - height) / 2
		color: _palette.color2
	}

	Misc.Text {
		id: description
		width: parent.width
		leftPadding: parent.favorite ? favoritesIndicator.width + parent.spacing : 0
		elide: Text.ElideRight
		wrapMode: wrapEnabled ? Text.Wrap : Text.NoWrap
		maximumLineCount: (styleData.hovered || styleData.selected) ? 2 : 1
		enabled: false

		Behavior on leftPadding {
			NumberAnimation { duration: 100 }
		}
	}
}
