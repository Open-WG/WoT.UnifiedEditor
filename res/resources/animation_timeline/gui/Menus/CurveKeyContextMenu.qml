import QtQuick 2.7
import Controls 1.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import MultiTangentHelper 1.0
import TangentModes 1.0
import "..//Constants.js" as Constants

BaseKeyContextMenu {
	id: root

	MultiTangentHelper {
		id: multiTangentHelper
	}

	property alias sequenceModel: multiTangentHelper.sequenceModel
	property alias selectionModel: multiTangentHelper.selectionModel

	readonly property bool smoothInTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.in == TangentModes.SMOOTH : TangentModes.NONE

	readonly property bool linearInTangentEnabled: 
		sequenceModel && selectionModel? multiTangentHelper.in == TangentModes.LINEAR : TangentModes.NONE

	readonly property bool steppedInTangetEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.in == TangentModes.STEPPED : TangentModes.NONE

	readonly property bool editabledInTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.in == TangentModes.FREE : TangentModes.NONE

	readonly property bool smoothOutTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.out == TangentModes.SMOOTH : TangentModes.NONE

	readonly property bool linearOutTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.out == TangentModes.LINEAR : TangentModes.NONE

	readonly property bool steppedOutTangetEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.out == TangentModes.STEPPED : TangentModes.NONE

	readonly property bool editabledOutTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.out == TangentModes.FREE : TangentModes.NONE

	readonly property bool brokenTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.isBroken : false

	KeyContextMenuSeparator { }

	function setInTangent(mode) {
		multiTangentHelper.in = mode
		multiTangentHelper.isBroken = true
		
		if (smoothOutTangentEnabled)
			multiKeyHelper.out = TangentModes.FREE

		multiTangentHelper.finalize(false)
	}

	function setOutTangent(mode) {
		multiTangentHelper.out = mode
		multiTangentHelper.isBroken = true
		
		if (smoothInTangentEnabled)
			multiKeyHelper.in = TangentModes.FREE

		multiTangentHelper.finalize(false)
	}

	MenuItem {
		id: smoothTangentItem

		checked: smoothInTangentEnabled && smoothOutTangentEnabled && !brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Smooth Tangent"

		onTriggered: {
			multiTangentHelper.in = TangentModes.SMOOTH
			multiTangentHelper.out = TangentModes.SMOOTH
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	MenuItem {
		id: linearTangentItem

		checked: linearOutTangentEnabled && linearInTangentEnabled && !brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Linear Tangent"

		onTriggered: {
			multiTangentHelper.in = TangentModes.LINEAR
			multiTangentHelper.out = TangentModes.LINEAR
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	MenuItem {
		id: steppedTangentItem

		checked: steppedInTangetEnabled && steppedOutTangetEnabled && !brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Stepped Tangent"

		onTriggered: {
			multiTangentHelper.in = TangentModes.STEPPED
			multiTangentHelper.out = TangentModes.STEPPED
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	MenuItem {
		id: editableTangentItem

		checked: editabledOutTangentEnabled && editabledInTangentEnabled && !brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Free Tangent"

		onTriggered: {
			multiTangentHelper.in = TangentModes.FREE
			multiTangentHelper.out = TangentModes.FREE
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	MenuItem {
		id: brokenTangentItem

		checked: brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Broken Tangent"

		onTriggered: {
			multiTangentHelper.isBroken = true

			if (smoothInTangentEnabled) 
				multiTangentHelper.in = TangentModes.FREE
			if (smoothOutTangentEnabled)
				multiTangentHelper.out = TangentModes.FREE
			
			multiTangentHelper.finalize(false)
		}
	}

	KeyContextMenuSeparator { }

	CurveKeyContextSubMenu {
		width: parent.width

		title: "In Tangent"

		MenuItem {
			id: smoothInTangentItem
			visible: false

			checked: smoothInTangentEnabled
			checkable: true

			width: parent.width

			text: "Smooth"

			onTriggered: {
			}
		}

		MenuItem {
			id: editabledInTangentItem

			checked: editabledInTangentEnabled && brokenTangentEnabled
			checkable: true

			height: 25
			width: parent.width

			text: "Free"

			onTriggered: {
				setInTangent(TangentModes.FREE)
			}
		}

		MenuItem {
			id: linearInTangentItem

			checked: linearInTangentEnabled && brokenTangentEnabled
			checkable: true

			height: 25
			width: parent.width

			text: "Linear"

			onTriggered: {
				setInTangent(TangentModes.LINEAR)
			}
		}

		MenuItem {
			id: steppedInTangentItem

			checked: steppedInTangetEnabled && brokenTangentEnabled
			checkable: true

			height: 25
			width: parent.width

			text: "Stepped"

			onTriggered: {
				setInTangent(TangentModes.STEPPED)
			}
		}
	}
	KeyContextMenuSeparator { }

	CurveKeyContextSubMenu {
		width: parent.width

		title: "Out Tangent"

		MenuItem {
			id: smoothOutTangentItem
			visible: false
			checked: smoothOutTangentEnabled
			checkable: true

			width: parent.width

			text: "Smooth"

			onTriggered: {
			}
		}

		MenuItem {
			id: editableOutTangentItem

			checked: editabledOutTangentEnabled && brokenTangentEnabled
			checkable: true
			
			height: 25
			width: parent.width

			text: "Free"

			onTriggered: {
				setOutTangent(TangentModes.FREE)
			}
		}

		MenuItem {
			id: linearOutTangentItem

			checked: linearOutTangentEnabled && brokenTangentEnabled
			checkable: true
			
			height: 25
			width: parent.width

			text: "Linear"

			onTriggered: {
				setOutTangent(TangentModes.LINEAR)
			}
		}

		MenuItem {
			id: steppedOutTangentItem

			checked: steppedOutTangetEnabled && brokenTangentEnabled
			checkable: true
			
			height: 25
			width: parent.width

			text: "Stepped"

			onTriggered: {
				setOutTangent(TangentModes.STEPPED)
			}
		}
	}
}