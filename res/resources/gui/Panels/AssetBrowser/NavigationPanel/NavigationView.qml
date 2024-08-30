import QtQml 2.2
import QtQuick 2.11
import QtQuick.Controls 1.4
import WGTools.Views 1.0 as Views
import WGTools.Views.Styles 1.0 as ViewStyles
import WGTools.Misc 1.0 as Misc
import WGTools.Controls.impl 1.0
import WGTools.Clickomatic 1.0 as Clickomatic
import "Delegates" as Delegates

Views.TreeView {
	id: view
	activeFocusOnTab: true
	alternatingRowColors: false
	headerVisible: false
	accesibleNameRole: nameColumn.role

	style: ViewStyles.TreeViewStyle {
		backgroundColor: _palette.color8
	}

	section.property: "assetCategory"
	section.delegate: Delegates.SectionDelegate {}

	onDoubleClicked: toggleExpanded(index)

	readonly property Connections __internalFlickableConnections: Connections {
		target: view.flickableItem
		onWidthChanged: {
			if (target.contentX > 0 && target.width > (target.contentWidth - target.contentX)) {
				target.contentX = Math.max(0, target.contentWidth - target.width)
			}
		}
	}

	readonly property Connections __internalSelectionConnections: Connections {
		target: view.selection
		onCurrentChanged: {
			if (current.valid) {
				view.expandAllParents(current)
				view.positionViewAtIndex(current, ListView.Visible)
			} else {
				view.positionViewAtBeginning()
			}
		}
	}

	Views.TableViewColumn {
		id: nameColumn
		title: "Name"
		role: "display"
		delegate: Delegates.ItemDelegate {
			Binding on ActiveFocus.when {
				value: styleData.index == view.currentIndex
				delayed: true
			}
			
			// clickomatic --------------------------------
			Accessible.name: accesibleNameGenerator.value
			Clickomatic.TableAccesibleNameGenerator {
				id: accesibleNameGenerator
				role: view.accesibleNameRole
				modelIndex: styleData.index
			}
			// --------------------------------------------
		}
	}
}
