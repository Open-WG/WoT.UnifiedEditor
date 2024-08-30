import QtQuick 2.7
import Controls 1.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "..//Constants.js" as Constants

Menu {
	id: root

	property var context: null

	delegate: AddSeqObjectPopupEntry {}

	AddSeqObjectPopupEntry {
		height: 30
		width: parent.width

		iconPath: Constants.iconDynamicModelObj
		label: "Model Object"

		onTriggered: {
			context.sequenceTreeModel.addModelObject()
		}
	}

	AddSeqObjectPopupEntry {
		height: 30
		width: parent.width

		iconPath: Constants.iconParticleObj
		label: "Particle Object"

		onTriggered: {
			context.sequenceTreeModel.addParticleObject()
		}
	}

	AddSeqObjectPopupEntry {
		height: 30
		width: parent.width

		iconPath: Constants.iconLightObj
		label: "Light Object"

		onTriggered: {
			context.sequenceTreeModel.addLightObject()
		}
	}

	AddSeqObjectPopupEntry {
		height: 30
		width: parent.width

		iconPath: Constants.iconSoundObj
		label: "Sound Object"

		onTriggered: {
			context.sequenceTreeModel.addSoundObject()
		}
	}
}
