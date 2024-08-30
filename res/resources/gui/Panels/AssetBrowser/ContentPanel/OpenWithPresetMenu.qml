import QtQml 2.2
import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0
import WGTools.Misc 1.0

Menu {
	id: openWithPreset
	property real __labelWidth: Math.max(radiusLabel.implicitWidth, edgeLabel.implicitWidth)
	property bool isSpace: true

	Repeater {
		model: ["MIN", "LOW", "MEDIUM", "HIGH", "MAX", "ULTRA"]

		delegate: MenuItem {
			function itemName(preset) {
				let r = preset.charAt(0) + preset.substr(1).toLowerCase();
				if (preset == context.currentGraphicsPreset) {
					r += " *"
				}
				return r;
			}

			text: itemName(modelData)
			onClicked: Qt.callLater(function(){ context.openCurrentAsset(false, modelData) }) 
		}
	}

	MenuSeparator {
		visible: isSpace
	}

	RowLayout {
		spacing: 10

		CheckBox {
			id: partialLoad
			visible: isSpace
			checked: context.partialSpaceLoad

			onToggled: {
				context.partialSpaceLoad = partialLoad.checked
			}
		}

		Text {
			visible: isSpace
			text: "Partial space loading"
		}
	}

	RowLayout {
		Text {
			id: radiusLabel
			visible: isSpace
			text: "Radius: "

			Layout.minimumWidth: openWithPreset.__labelWidth
		}

		Slider {
			id: radius
			visible: isSpace
			enabled: partialLoad.checked
			stepSize: 1
			from: 1
			to: 10
			value: context.spaceLoadRadius

			Layout.fillWidth: true

			onMoved: {
				context.spaceLoadRadius = radius.value
			}
		}
	}

	RowLayout {
		Text {
			id: edgeLabel
			visible: isSpace
			text: "Edge: "
			
			Layout.minimumWidth: openWithPreset.__labelWidth
		}

		Slider {
			id: edge
			visible: isSpace
			enabled: partialLoad.checked
			stepSize: 1
			from: 0
			to: 5
			value: context.spaceLoadEdgeWidth

			Layout.fillWidth: true

			onMoved: {
				context.spaceLoadEdgeWidth = edge.value
			}
		}
	}
}
