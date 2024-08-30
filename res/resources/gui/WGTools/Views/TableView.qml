import QtQuick 2.7
import QtQuick.Controls 1.4
import WGTools.Views.Details 1.0 as Details
import WGTools.Views.Styles 1.0 as Styles

TableView {
	id: table
	readonly property real rowHeight: rowLoader.item ? rowLoader.item.height : 0
	readonly property real headerHeight: headerLoader.item ? headerLoader.item.height: 0

	style: Styles.TableViewStyle {}
	frameVisible: false

	signal headerMenuRequested(int column)

	headerDelegate: Details.TableViewHeader {
		id: header
		view: table

		onMenuRequested: {
			table.headerMenuRequested(column)
		}
	}
	
	Details.ScrollHelper {}

	Loader {
		id: rowLoader
		

		sourceComponent: table.rowDelegate

		property QtObject styleData: QtObject {
			readonly property int row: -1
			readonly property bool alternate: false
			readonly property bool selected: false
			readonly property bool hasActiveFocus: false
			readonly property bool pressed: false
		}
		Binding {
			target: rowLoader.item
			property: "visible"
			value: false
		}

		Binding {
			target: rowLoader.item
			property: "enabled"
			value: false
		}
	}

	Loader {
		id: headerLoader

		sourceComponent: table.headerDelegate
		property QtObject styleData: QtObject {
			readonly property int row: -1
			readonly property bool alternate: false
			readonly property bool selected: false
			readonly property bool hasActiveFocus: false
			readonly property bool pressed: false
			readonly property string value: ""
		}
		Binding {
			target: headerLoader.item
			property: "visible"
			value: false
		}

		Binding {
			target: headerLoader.item
			property: "enabled"
			value: false
		}

	}

}
