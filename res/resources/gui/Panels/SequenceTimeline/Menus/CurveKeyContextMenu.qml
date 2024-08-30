import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import WGTools.Controls 2.0 as Controls
import WGTools.AnimSequences 1.0

import "..//Constants.js" as Constants

BaseKeyContextMenu {
	id: root

	MultiTangentHelper {
		id: multiTangentHelper
	}

	property alias sequenceModel: multiTangentHelper.sequenceModel
	property alias selectionModel: multiTangentHelper.selectionModel

	readonly property bool smoothInTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.in == TangentMode.SMOOTH : TangentMode.NONE

	readonly property bool linearInTangentEnabled: 
		sequenceModel && selectionModel? multiTangentHelper.in == TangentMode.LINEAR : TangentMode.NONE

	readonly property bool steppedInTangetEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.in == TangentMode.STEPPED : TangentMode.NONE

	readonly property bool editabledInTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.in == TangentMode.FREE : TangentMode.NONE

	readonly property bool smoothOutTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.out == TangentMode.SMOOTH : TangentMode.NONE

	readonly property bool linearOutTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.out == TangentMode.LINEAR : TangentMode.NONE

	readonly property bool steppedOutTangetEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.out == TangentMode.STEPPED : TangentMode.NONE

	readonly property bool editabledOutTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.out == TangentMode.FREE : TangentMode.NONE

	readonly property bool brokenTangentEnabled: 
		sequenceModel && selectionModel ? multiTangentHelper.isBroken : false

	KeyContextMenuSeparator { }

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

	Controls.MenuItem {
		id: smoothTangentItem

		checked: smoothInTangentEnabled && smoothOutTangentEnabled && !brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Smooth Tangent"

		onTriggered: {
			multiTangentHelper.in = TangentMode.SMOOTH
			multiTangentHelper.out = TangentMode.SMOOTH
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	Controls.MenuItem {
		id: linearTangentItem

		checked: linearOutTangentEnabled && linearInTangentEnabled && !brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Linear Tangent"

		onTriggered: {
			multiTangentHelper.in = TangentMode.LINEAR
			multiTangentHelper.out = TangentMode.LINEAR
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	Controls.MenuItem {
		id: steppedTangentItem

		checked: steppedInTangetEnabled && steppedOutTangetEnabled && !brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Stepped Tangent"

		onTriggered: {
			multiTangentHelper.in = TangentMode.STEPPED
			multiTangentHelper.out = TangentMode.STEPPED
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	Controls.MenuItem {
		id: editableTangentItem

		checked: editabledOutTangentEnabled && editabledInTangentEnabled && !brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Free Tangent"

		onTriggered: {
			multiTangentHelper.in = TangentMode.FREE
			multiTangentHelper.out = TangentMode.FREE
			multiTangentHelper.isBroken = false
			multiTangentHelper.finalize(false)
		}
	}

	Controls.MenuItem {
		id: brokenTangentItem

		checked: brokenTangentEnabled
		checkable: true

		height: 25
		width: parent.width

		text: "Broken Tangent"

		onTriggered: {
			multiTangentHelper.isBroken = true

			if (smoothInTangentEnabled) 
				multiTangentHelper.in = TangentMode.FREE
			if (smoothOutTangentEnabled)
				multiTangentHelper.out = TangentMode.FREE
			
			multiTangentHelper.finalize(false)
		}
	}

	KeyContextMenuSeparator { }

	CurveKeyContextSubMenu {
		width: parent.width

		title: "In Tangent"

		Controls.MenuItem {
			id: smoothInTangentItem
			visible: false

			checked: smoothInTangentEnabled
			checkable: true

			width: parent.width

			text: "Smooth"

			onTriggered: {
			}
		}

		Controls.MenuItem {
			id: editabledInTangentItem

			checked: editabledInTangentEnabled && brokenTangentEnabled
			checkable: true

			height: 25
			width: parent.width

			text: "Free"

			onTriggered: {
				setInTangent(TangentMode.FREE)
			}
		}

		Controls.MenuItem {
			id: linearInTangentItem

			checked: linearInTangentEnabled && brokenTangentEnabled
			checkable: true

			height: 25
			width: parent.width

			text: "Linear"

			onTriggered: {
				setInTangent(TangentMode.LINEAR)
			}
		}

		Controls.MenuItem {
			id: steppedInTangentItem

			checked: steppedInTangetEnabled && brokenTangentEnabled
			checkable: true

			height: 25
			width: parent.width

			text: "Stepped"

			onTriggered: {
				setInTangent(TangentMode.STEPPED)
			}
		}
	}
	KeyContextMenuSeparator { }

	CurveKeyContextSubMenu {
		width: parent.width

		title: "Out Tangent"

		Controls.MenuItem {
			id: smoothOutTangentItem
			visible: false
			checked: smoothOutTangentEnabled
			checkable: true

			width: parent.width

			text: "Smooth"

			onTriggered: {
			}
		}

		Controls.MenuItem {
			id: editableOutTangentItem

			checked: editabledOutTangentEnabled && brokenTangentEnabled
			checkable: true
			
			height: 25
			width: parent.width

			text: "Free"

			onTriggered: {
				setOutTangent(TangentMode.FREE)
			}
		}

		Controls.MenuItem {
			id: linearOutTangentItem

			checked: linearOutTangentEnabled && brokenTangentEnabled
			checkable: true
			
			height: 25
			width: parent.width

			text: "Linear"

			onTriggered: {
				setOutTangent(TangentMode.LINEAR)
			}
		}

		Controls.MenuItem {
			id: steppedOutTangentItem

			checked: steppedOutTangetEnabled && brokenTangentEnabled
			checkable: true
			
			height: 25
			width: parent.width

			text: "Stepped"

			onTriggered: {
				setOutTangent(TangentMode.STEPPED)
			}
		}
	}
}