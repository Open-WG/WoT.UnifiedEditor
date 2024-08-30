import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Controls.Controllers 1.0
import WGTools.PropertyGrid 1.0 as PG
import WGTools.Resources 1.0 as WGTResources
import WGTools.DialogsQml 1.0 as Dialogs
import WGTools.Misc 1.0 as Misc
// import WGTools.Controls.impl 1.0 as Impl
import "../../Settings.js" as Settings

TextField {
	id: control

	property alias verifier: verifier

	property var valueData
	property var isPath: false
	property bool anyDir: propertyData ? propertyData.dialog.anyDir: false
	property bool allowedToBeEmpty: true // TODO: looks like the property is deprecated. Consider to use PropertyValueVerifier instead.
	readonly property bool undefinedState: valueData == undefined || valueData.value == undefined;

	readOnly: valueData == undefined || valueData.readonly
	prefix.concatenate: valueData && valueData.prefixData.concatenate
	prefix.text: valueData ? valueData.prefixData.prefix : ""

	Accessible.name: "Text box"
	Keys.forwardTo: controller

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

	Binding {
		target: control.background.border
		property: "color"
		value: _palette.color14
		when: !verifier.valid
	}

	PG.PropertyValueVerifier {
		id: verifier
		propertyData: control.valueData
		value: control.text
		enabled: !control.readOnly
	}

	TextFieldController {
		id: controller
		enabled: control.valueData != null
		transientEnabled: control.valueData && control.valueData.transientEnabled == true

		onModified: {
			// current branch restriction for paths
			if (isPath && !anyDir && !undefinedState && !readOnly && commit) {
				if (!checkBranch.check(control.text)) {
					control.undo()
					return
				}
			}

			if (!allowedToBeEmpty && control.text.length == 0 && commit) {
				control.undo()
				return
			}

			if (!valueData.setValue(control.text, !commit ? PG.IValueData.TRANSIENT : 0)) {
				control.text = controller.oldValue
			}
		}

		onRollback: {
			control.text = control.undefinedState ? Settings.undefinedStateStringValue : valueData.value
			control.valueData.rollback()
		}
	}

	Dialogs.CheckBranchDialog {
		id: checkBranch
	}

	TextFieldErrorTooltip {}

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

	Misc.QmlEventFilter {
		target: control
	}
}
