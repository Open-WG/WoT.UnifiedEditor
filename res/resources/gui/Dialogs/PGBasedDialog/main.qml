import QtQuick 2.11
import QtQml.Models 2.11
import QtQml.StateMachine 1.0 as DSM
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0 as View

Rectangle {
	id: root
	color: _palette.color8

	Accessible.name: qmlView.title
	property int minimumHeight: 0

	Binding on minimumHeight {
		value: propertyGridView.implicitHeight + footer.height
		when: populatedState.active
	}

	// Workaround. Don't be mad at me ;) To fix it properly we have to reconsider PropertyGrid population mechanizm
	DSM.StateMachine {
		initialState: populatingState
		running: true

		DSM.State {
			id: populatingState
			onEntered: prevImplicitHeight = propertyGridView.implicitHeight

			property int prevImplicitHeight

			DSM.TimeoutTransition {
				targetState: populatingState.prevImplicitHeight == propertyGridView.implicitHeight ? populatedState : populatingState
				timeout: 0
			}
		}

		DSM.State {
			id: populatedState
		}
	}

	View.PropertyGrid {
		id: propertyGridView
		width: parent.width
		height: footer.y

		model: PropertyGridModel {
			id: pgModel
			source: context.object
		}

		selection: ItemSelectionModel {
			model: pgModel
		}
	}

	Item {
		id: footer
		width: parent.width
		height: context.showDialogButtons ? buttons.height : 0
		visible: context.showDialogButtons

		anchors.bottom: parent.bottom

		Rectangle { // separator
			height: 1
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: 8
			anchors.rightMargin: 8
			color: _palette.color9
		}

		Row {
			id: buttons
			spacing: 5
			padding: spacing
			anchors.right: parent.right

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Ok"
				enabled: (!context.hasOwnProperty("acceptable") || context.acceptable) && (propertyGridView.invalidDelegateCount == 0)
				onClicked: context.accept()
			}

			Controls.Button {
				implicitWidth: ControlsSettings.width
				text: "Cancel"
				onClicked: context.reject()
			}
		}
	}
}
