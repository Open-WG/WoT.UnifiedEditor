import QtQuick 2.7
import WGTools.Misc 1.0 as Misc
import "../../../../Common" as Common

Item {
	id: root

	property int index
	property var model

	property string tagNameRole: "tagName"
	property string tagColorRole: "tagColor"
	property string matchPosRole: "matchPos"
	property string matchLenRole: "matchLen"
	property string assetCountRole: "assetCount"

	implicitWidth: iconArea.width + title.width

	QtObject {
		id: p // private

		readonly property string tagName: getModelData(root.tagNameRole)
		readonly property color tagColor: getModelData(root.tagColorRole, "black")
		readonly property int   matchPos: getModelData(root.matchPosRole, 0)
		readonly property int   matchLen: getModelData(root.matchLenRole, 0)
		readonly property int assetCount: getModelData(root.assetCountRole, 0)

		function getModelData(role, defaultValue) {
			if (root.model != null && typeof root.model[role] != "undefined")
				return root.model[role]

			if (typeof defaultValue == "undefined")
				defaultValue = ""

			return defaultValue
		}
	}

	Item {
		id: iconArea
		width: 30
		height: parent.height

		Common.TagIcon {
			id: icon
			text: p.tagName
			color: p.tagColor
			anchors.centerIn: parent
		}
	}

	Misc.Text {
		id: title
		
		anchors.left: iconArea.right
		anchors.right: root.right
		anchors.verticalCenter: root.verticalCenter

		enabled: false
		textFormat: Text.RichText
		text: {
			var res

			if (p.matchLen != 0)
			{
				res = p.tagName.substr(0, p.matchPos)
				res += '<b><font color="' + _palette.color1 + '">'
				res += p.tagName.substr(p.matchPos, p.matchLen)
				res += '</font></b>'
				res += p.tagName.substr(p.matchPos + p.matchLen)
			}
			else
			{
				res = p.tagName
			}
			
			if (p.assetCount != 0)
			{
				res += '<font color="' + _palette.color3 + '">'
				res += ' — ' + p.assetCount.toString() + " item"

				if (p.assetCount != 1)
					res += "s"

				res += '</font>'
			}
			
			return res
		}
	}
}
