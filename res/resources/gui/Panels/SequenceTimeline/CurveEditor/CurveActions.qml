import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.AnimSequences 1.0
import WGTools.Misc 1.0 as Misc
import Panels.SequenceTimeline 1.0

Misc.ActionsHolder {
	id: root

	property alias sequenceModel: multiTangentHelper.sequenceModel
	property alias selectionModel: multiTangentHelper.selectionModel

	readonly property bool dataReady: sequenceModel && selectionModel && multiTangentHelper.enabled
	readonly property bool smoothInTangentEnabled: dataReady ? multiTangentHelper.in == TangentMode.SMOOTH : TangentMode.NONE
	readonly property bool linearInTangentEnabled: dataReady ? multiTangentHelper.in == TangentMode.LINEAR : TangentMode.NONE
	readonly property bool steppedInTangetEnabled: dataReady ? multiTangentHelper.in == TangentMode.STEPPED : TangentMode.NONE
	readonly property bool editabledInTangentEnabled: dataReady ? multiTangentHelper.in == TangentMode.FREE : TangentMode.NONE
	readonly property bool smoothOutTangentEnabled: dataReady ? multiTangentHelper.out == TangentMode.SMOOTH : TangentMode.NONE
	readonly property bool linearOutTangentEnabled: dataReady ? multiTangentHelper.out == TangentMode.LINEAR : TangentMode.NONE
	readonly property bool steppedOutTangetEnabled: dataReady ? multiTangentHelper.out == TangentMode.STEPPED : TangentMode.NONE
	readonly property bool editabledOutTangentEnabled: dataReady ? multiTangentHelper.out == TangentMode.FREE : TangentMode.NONE
	readonly property bool brokenTangentEnabled: dataReady ? multiTangentHelper.isBroken : false

	property var helper: MultiTangentHelper { id: multiTangentHelper }

	function setInTangent(mode) {
		multiTangentHelper.in = mode
		multiTangentHelper.isBroken = true
		
		if (smoothOutTangentEnabled)
			multiKeyHelper.out = TangentMode.FREE

		multiTangentHelper.finalize(false)
	}

	function setOutTangent(mode) {
		multiTangentHelper.out = mode
		multiTangentHelper.isBroken = true
		
		if (smoothInTangentEnabled)
			multiKeyHelper.in = TangentMode.FREE

		multiTangentHelper.finalize(false)
	}

	Action {
		objectName: "smoothTangent"
		text: "Smooth Tangent"
		checked: smoothInTangentEnabled && smoothOutTangentEnabled && !brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		icon.name: Constants.tangentSmooth

		onTriggered: {
			multiTangentHelper.in = TangentMode.SMOOTH
			multiTangentHelper.out = TangentMode.SMOOTH
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	Action {
		objectName: "linearTangent"
		text: "Linear Tangent"
		checked: linearOutTangentEnabled && linearInTangentEnabled && !brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		icon.name: Constants.tangentLinear

		onTriggered: {
			multiTangentHelper.in = TangentMode.LINEAR
			multiTangentHelper.out = TangentMode.LINEAR
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	Action {
		objectName: "steppedTangent"
		text: "Stepped Tangent"
		checked: steppedInTangetEnabled && steppedOutTangetEnabled && !brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		icon.name: Constants.tangentStepped

		onTriggered: {
			multiTangentHelper.in = TangentMode.STEPPED
			multiTangentHelper.out = TangentMode.STEPPED
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	Action {
		objectName: "freeTangent"
		text: "Free Tangent"
		checked: editabledOutTangentEnabled && editabledInTangentEnabled && !brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		icon.name: Constants.tangentFree

		onTriggered: {
			multiTangentHelper.in = TangentMode.FREE
			multiTangentHelper.out = TangentMode.FREE
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	Action {
		objectName: "brokenTangent"
		text: "Broken Tangent"
		checked: brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		icon.name: Constants.tangentBroken

		onTriggered: {
			multiTangentHelper.isBroken = true

			if (smoothInTangentEnabled) 
				multiTangentHelper.in = TangentMode.FREE
			if (smoothOutTangentEnabled)
				multiTangentHelper.out = TangentMode.FREE
			
			multiTangentHelper.finalize(false)
		}
	}

	/////////////////////////////////////////////

	Action {
		objectName: "smoothInTangent"
		text: "Smooth"
		checked: smoothInTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		onTriggered: {}
	}

	Action {
		objectName: "freeInTangent"
		text: "Free"
		checked: editabledInTangentEnabled && brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		onTriggered: {
			setInTangent(TangentMode.FREE)
		}
	}

	Action {
		objectName: "linearInTangent"
		text: "Linear"
		checked: linearInTangentEnabled && brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		onTriggered: {
			setInTangent(TangentMode.LINEAR)
		}
	}

	Action {
		objectName: "steppedInTangent"
		text: "Stepped"
		checked: steppedInTangetEnabled && brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		onTriggered: {
			setInTangent(TangentMode.STEPPED)
		}
	}

	/////////////////////////////////////////////

	Action {
		objectName: "smoothOutTangent"
		text: "Smooth"
		checked: smoothOutTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		onTriggered: {}
	}

	Action {
		objectName: "freeOutTangent"
		text: "Free"
		checked: editabledOutTangentEnabled && brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		onTriggered: {
			setOutTangent(TangentMode.FREE)
		}
	}

	Action {
		objectName: "linearOutTangent"
		text: "Linear"
		checked: linearOutTangentEnabled && brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		onTriggered: {
			setOutTangent(TangentMode.LINEAR)
		}
	}

	Action {
		objectName: "steppedOutTangent"
		text: "Stepped"
		checked: steppedOutTangetEnabled && brokenTangentEnabled
		checkable: true
		enabled: multiTangentHelper.enabled

		onTriggered: {
			setOutTangent(TangentMode.STEPPED)
		}
	}
}
