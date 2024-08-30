import QtQuick 2.11
import QtQml.StateMachine 1.11 as SM

SM.StateMachine {
	id: machine

	property Flickable flickable: null
	property var model: null

	readonly property bool inited: flickable != null && model != null
	property real position: 0

	initialState: inited ? initializedState : uninitializedState
	running: true

	SM.State {
		id: uninitializedState

		SM.SignalTransition {
			targetState: initializedState
			signal: machine.initedChanged
		}
	}

	SM.State {
		id: initializedState
		initialState: machine.flickable.contentHeight ? filledState : resettingState

		SM.State {
			id: filledState
			onEntered: {
				machine.flickable.contentY = machine.flickable.contentHeight * machine.position
			}

			SM.SignalTransition {
				targetState: resettingState
				signal: machine.model.modelAboutToBeReset
			}
		}

		SM.State {
			id: resettingState
			onEntered: {
				if (machine.flickable.contentHeight) {
					machine.position = machine.flickable.contentY / machine.flickable.contentHeight
				} else {
					machine.position = 0
				}
			}

			SM.SignalTransition {
				targetState: fillingState
				signal: machine.model.modelReset
			}
		}

		SM.State {
			id: fillingState

			SM.SignalTransition {
				targetState: filledState
				signal: machine.flickable.contentHeightChanged
				guard: machine.flickable.contentHeight != 0
			}
		}

		SM.SignalTransition {
			targetState: uninitializedState
			signal: machine.initedChanged
		}
	}
}
