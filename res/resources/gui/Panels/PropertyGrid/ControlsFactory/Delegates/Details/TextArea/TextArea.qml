import QtQuick 2.7
import QtQuick.Controls 2.4
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Controllers 1.0
import WGTools.Resources 1.0 as WGTResources
import WGTools.Misc 1.0 as Misc
import WGTools.PropertyGrid 1.0 as PG
import "../../Settings.js" as Settings
import "../TextField"

Flickable {
	id: flickable

	property alias valueData: control.valueData
	readonly property alias undefinedState: control.undefinedState

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight

	Controls.TextArea {
		id: control

		width: parent.width
		height: parent.height

		property var valueData
		readonly property bool undefinedState: valueData == undefined || valueData.value == undefined;

		Accessible.name: "Text area"

		readOnly: valueData == undefined || valueData.readonly

		onActiveFocusChanged: {
			if (activeFocus && undefinedState) {
				selectAll()
			}
		}

		Binding on text {
			value: control.undefinedState
				? Settings.undefinedStateStringValue
				: valueData.value
		}

		Keys.forwardTo: controller
		TextAreaController {
			id: controller
			onModified: {
				valueData.setValue(
					control.text,
					!commit ? PG.IValueData.TRANSIENT : 0
				)
			}
		}

		DropArea {
			keys: [ "text/uri-list", "text/plain" ]
			anchors.fill: parent

			onDropped: {
				if (drop.urls.length == 1) {
					valueData.setValue(WGTResources.Resources.fileNameFromUrl(drop.urls[0]))
				}
				else if (drop.hasText) {
					valueData.setValue(drop.text)
				}
			}
		}

		background: {}

		Misc.QmlEventFilter {
			target: control
		}
	}
}
