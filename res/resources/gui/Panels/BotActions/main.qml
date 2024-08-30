import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Styles.Text 1.0 as StyledText
import "Details" as Details

ControlsEx.Panel {
	id: botActions

	title: "Actions"
	layoutHint: "right"

	implicitWidth: 400
	implicitHeight: 400

	Component {
		id: firstColumnDelegate
		RowLayout {
			StyledText.BaseRegular {
				elide: Text.ElideRight
				Layout.fillWidth: true
				text: styleData.value
			}
		}
	}

	Component {
		id: columnDelegate
		Controls.TextField {
			text: styleData.value
			readOnly: true
		}
	}

	Details.Tree {
		id: goalsTree
		model: context.goalsModel
		selection: context.goalsSelectionModel

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: globalTriggersTree.top

		TableViewColumn {
			title: "Goals"
			role: "name"

			delegate: firstColumnDelegate
		}

		TableViewColumn {
			title: "Type"
			role: "type"

			delegate: columnDelegate
		}

		TableViewColumn {
			title: "Data"
			role: "data"

			delegate: columnDelegate
		}
		
		TableViewColumn {
			title: "Next Goal"
			role: "nextGoal"

			delegate: columnDelegate
		}
	}

	Details.Tree {
		id: globalTriggersTree
		model: context.globalTriggersModel
		selection: context.globalTriggersSelectionModel

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parametersTree.top
		height: 150

		TableViewColumn {
			title: "Global Triggers"
			role: "name"

			delegate: firstColumnDelegate
		}

		TableViewColumn {
			title: "Type"
			role: "type"

			delegate: columnDelegate
		}

		TableViewColumn {
			title: "Data"
			role: "data"

			delegate: columnDelegate
		}
		
		TableViewColumn {
			title: "Next Goal"
			role: "nextGoal"

			delegate: columnDelegate
		}
	}

	Details.Tree {
		id: parametersTree
		model: context.parametersModel
		selection: context.parametersSelectionModel
		
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		height: 150

		TableViewColumn {
			title: "Parameters"
			role: "type"
			
			delegate: firstColumnDelegate
		}

		TableViewColumn {
			title: "Value"
			role: "value"
			
			delegate: columnDelegate
		}
	}
}
