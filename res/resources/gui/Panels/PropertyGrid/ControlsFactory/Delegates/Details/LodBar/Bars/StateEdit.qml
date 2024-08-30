import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0
import WGTools.Controls.Controllers 1.0
import WGTools.Misc 1.0 as Misc
import "../../../Settings.js" as Settings

FocusScope {
	id: root

	readonly property bool modelExists: typeof model != "undefined"
	signal finishEditing()

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight
	width: parent.width
	height: parent.height
	enabled: focus

	onFocusChanged: {
		if (focus) {
			spinbox.focus = true
		}
	}

	Keys.onEscapePressed: finishEditing()
	Keys.onReturnPressed: finishEditing()
	Keys.onEnterPressed: finishEditing()

	RowLayout {
		id: layout
		anchors.verticalCenter: parent.verticalCenter
		width: parent.width
		spacing: Settings.lodDelegateSpacing

		Misc.Text {
			text: root.modelExists ? model.lod.name : ""
			font.capitalization: Font.AllUppercase

			Layout.alignment: Qt.AlignVCenter
		}

		DoubleSpinBox {
			id: spinbox
			from: root.modelExists ? model.lod.extentLimitsStart : 0
			to: root.modelExists ? model.lod.extentLimitsEnd : Infinity
			decimals: root.modelExists ? model.lod.decimals : 0
			stepSize: root.modelExists ? model.lod.stepSize : 1
			units: Settings.lodExtentUnits

			textFromValue: function(value, locale) {
				if (root.modelExists && model.lod.infinite) {
					return Settings.lodInfinityText
				}
				
				return Number(value).toLocaleString(locale, 'f', decimals) + postfixText
			}

			onActiveFocusChanged: {
				contentItem.selectAll()
			}

			Layout.alignment: Qt.AlignVCenter
			Keys.forwardTo: controller
			KeyNavigation.right: infiniteButton

			Binding on value {
				when: root.modelExists
				value: root.modelExists ? model.lod.extentEnd : spinbox.value
			}

			SpinBoxController {
				id: controller
				onModified: {
					model.lod.setExtent(spinbox.value, !commit)
				}
			}

			Connections {
				target: spinbox.contentItem
				ignoreUnknownSignals: true
				onEditingFiniched: {
					root.finishEditing()
				}
			}
		}

		Button {
			id: infiniteButton
			flat: true
			visible: root.modelExists && !model.lod.next;
			enabled: root.modelExists && !model.lod.infinite && visible
			icon.source: "image://gui/icon-lod-infinity"

			Layout.alignment: Qt.AlignVCenter
			KeyNavigation.right: removeButton

			onClicked: {
				model.lod.makeInfinite()
			}
		}

		Button {
			id: removeButton
			flat: true
			enabled: root.modelExists && !model.firstLod
			icon.source: "image://gui/icon-lod-delete"

			Layout.alignment: Qt.AlignVCenter
			KeyNavigation.right: closeButton

			onClicked: {
				model.lod.remove()
				root.finishEditing()
			}
		}

		Item {
			Layout.fillWidth: true
		}

		Button {
			id: closeButton
			flat: true
			icon.source: "image://gui/icon-lod-ok"

			Layout.alignment: Qt.AlignVCenter
			Layout.leftMargin: -layout.spacing
			KeyNavigation.right: spinbox

			onClicked: {
				root.finishEditing()
			}
		}
	}
}
