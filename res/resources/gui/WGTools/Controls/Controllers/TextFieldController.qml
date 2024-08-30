import QtQuick 2.11
import QtQml.StateMachine 1.0 as SM

MouseArea {
	id: controller

	property Item control: parent
	property bool transientEnabled: true
	property var oldValue

	signal modified(bool commit)
	signal rollback()

	width: parent.width; height: parent.height; z: -1
	acceptedButtons: Qt.NoButton

	SM.StateMachine {
		id: sm
		initialState: initState
		running: controller.enabled

		SM.State {
			id: initState
			onEntered: controller.control.dirty = false
			onExited: controller.oldValue = controller.control.valueData.value
			SM.SignalTransition {targetState: transientCommitState; signal: controller.control.textEdited; guard: controller.transientEnabled}
			SM.SignalTransition {targetState: modifiedState; signal: controller.control.textEdited; guard: !controller.transientEnabled}
		}

		SM.State {
			id: modifiedState
			onEntered: controller.control.dirty = true
			SM.SignalTransition {targetState: rollbackState; signal: controller.Keys.escapePressed}
			SM.SignalTransition {targetState: transientCommitState; signal: controller.control.textEdited; guard: controller.transientEnabled}
			SM.SignalTransition {targetState: commitState; signal: controller.control.editingFinished}
		}

		SM.State {
			id: rollbackState
			onEntered: controller.rollback()
			SM.TimeoutTransition {targetState: initState; timeout: 0}
		}

		SM.State {
			id: transientCommitState
			onEntered: controller.modified(false)
			SM.TimeoutTransition {targetState: modifiedState; timeout: 0}
		}

		SM.State {
			id: commitState
			onEntered: controller.modified(true)
			SM.TimeoutTransition {targetState: initState; timeout: 0}
		}
	}
}
