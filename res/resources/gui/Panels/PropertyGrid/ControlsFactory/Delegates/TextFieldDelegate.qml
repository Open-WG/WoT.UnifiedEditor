import QtQuick 2.11
import WGTools.PropertyGrid 1.0
import "Details/TextField" as Details

PropertyDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitWidth: control.implicitWidth
	implicitHeight: control.implicitHeight
	propertyData: model ? model.node.property : null
	enabled: true

	function initialize() {
		if (!control.verifier.valid) {
			propertyGrid.invalidDelegateCount++;
		}

		verifierConnection.enabled = true;
	}

	function finalize() {
		verifierConnection.enabled = false;

		if (!control.verifier.valid) {
			propertyGrid.invalidDelegateCount--;
		}
	}

	Connections {
		id: verifierConnection
		target: control.verifier
		onValidChanged: {
			if (control.verifier.valid) {
				propertyGrid.invalidDelegateCount--;
			} else {
				propertyGrid.invalidDelegateCount++;
			}
		}
	}

	Details.TextField {
		id: control
		width: parent.width
		height: parent.height
		valueData: propertyData
		overridden: propertyData && propertyData.overridden
		wrapMode: Text.NoWrap
	}
}
