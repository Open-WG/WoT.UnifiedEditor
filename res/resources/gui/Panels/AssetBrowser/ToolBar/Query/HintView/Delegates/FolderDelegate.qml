import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Item {
	id: root

	property int index
	property var model
	property string folderNameRole: "display"
	property string folderPathRole: "path"
	property string matchPosRole: "matchPos"
	property string matchLenRole: "matchLen"

	readonly property alias folderTextWidth: folderText.width
	property alias folderAreaWidth: folderTextArea.width

	QtObject {
		id: p // private

		readonly property string folderName: getModelData(root.folderNameRole)
		readonly property string folderPath: getModelData(root.folderPathRole)
		readonly property int matchPos: getModelData(root.matchPosRole, 0)
		readonly property int matchLen: getModelData(root.matchLenRole, 0)

		function getModelData(role, defaultValue) {
			if (root.model !== null && role !== "")
			{
				var rolePieces = role.split('.')
				var value = root.model

				for (var i = 0; i < rolePieces.length; i++)
				{
					var key = rolePieces[i]
					if (typeof value[key] !== "undefined")
					{
						value = value[key]
					}
				}

				if (value !== root.model && typeof value !== "undefined")
				{
					return value
				}
			}

			if (typeof defaultValue === "undefined")
				defaultValue = ""

			return defaultValue
		}
	}

	Item {
		id: iconArea
		width: 30
		height: parent.height

		Image {
			id: icon
			source: "image://gui/icon-folder"
			anchors.centerIn: parent
		}
	}

	Item {
		id: folderTextArea
		implicitWidth: folderText.width
		height: parent.height

		anchors.left: iconArea.right

		Behavior on width {
			id: widthBehavior
			enabled: folderTextArea.width > 0

			NumberAnimation {
				duration: 100
				easing.type: Easing.OutQuad
			}
		}

		Misc.Text {
			id: folderText
			enabled: false
			textFormat: Text.RichText
			text: {
				var res

				if (p.matchLen != 0)
				{
					res = p.folderName.substr(0, p.matchPos)
					res += '<b><font color="' + _palette.color1 + '">'
					res += p.folderName.substr(p.matchPos, p.matchLen)
					res += '</font></b>'
					res += p.folderName.substr(p.matchPos + p.matchLen)
				}
				else
				{
					res = p.folderName
				}
				
				return res
			}

			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
		}
	}

	Misc.Text {
		id: pathText
		enabled: false
		color: _palette.color3
		textFormat: Text.RichText
		text: p.folderPath + '/' + folderText.text

		anchors.verticalCenter: root.verticalCenter
		anchors.left: folderTextArea.right
		anchors.leftMargin: 10
		anchors.right: root.right
	}
}
