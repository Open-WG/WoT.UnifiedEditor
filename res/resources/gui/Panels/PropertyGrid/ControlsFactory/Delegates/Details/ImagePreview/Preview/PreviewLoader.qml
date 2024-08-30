import QtQuick 2.7
import "../../../../../../AtlasEditor"
import WGTools.AtlasEditor 1.0
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.States 1.0 as States

Item {
	id: root
	property var source
	property var atlasData
	property var atlasType
	readonly property bool isAtlas : source == ""
	property var settings
	property bool showAtlasNumbers: false
	property bool showEmptySlotIcons: false
	property bool showSingle: false

	Component {
		id: atlas

		Item {
			QtAtlasModel {
				id: dataModel
				source: root.atlasData
			   // selection: context.selectionModel
			}

			Atlas {
				model: dataModel
				viewSettings: root.settings
			  //  selection: context.selectionModel
				width: root.width
				height: root.height
				showNumbers: root.showAtlasNumbers
				showEmptySlotIcons: root.showEmptySlotIcons
				atlasWidth: showSingle ? width : dataModel.atlasWidth
				atlasHeight: showSingle ? height : dataModel.atlasHeight
				rowCount: showSingle ? 1 : dataModel.rowCount
				columnCount: showSingle ? 1 : dataModel.columnCount
			}

			Component.onCompleted: {
				root.settings.tileType = root.atlasType
			}
		}
	}

	Component {
		id: singleTexture

		Item {
			ControlsEx.ChannelViewImage {
				id: img
				property PreviewSettings settings : root.settings
				source: root.source
				width: root.width
				height: root.height
				visible: !loading.isVisible

				Binding { target: img.effect; property: "redEnabled";   value: settings.red;   when: settings }
				Binding { target: img.effect; property: "greenEnabled"; value: settings.green; when: settings }
				Binding { target: img.effect; property: "blueEnabled";  value: settings.blue;  when: settings }
				Binding { target: img.effect; property: "alphaEnabled"; value: settings.alpha; when: settings }
			}

			States.StateLoading {
				id: loading
				visible: img.isLoading
				anchors.fill: img
			}
		}
	}

	Loader {
		id: loader
		sourceComponent: isAtlas ? atlas : singleTexture
	}
}
