import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0 as Details

Menu {
	property bool active: false

	id: tankFilterMenu
	modal: true
	width: 233

	x: (parent.width - width) / 2
	y: parent.height

	// Type filter
	MenuHeader { text: "Filter by type" }
	TankFilterMenuLayout {
		id: type
		model:
		ListModel {
			ListElement {icon: "image://gui/light_tank_icon"; filter: "$tank_type=lightTank"}
			ListElement {icon: "image://gui/medium_tank_icon"; filter: "$tank_type=mediumTank"}
			ListElement {icon: "image://gui/heavy_tank_icon"; filter: "$tank_type=heavyTank"}
			ListElement {icon: "image://gui/tank_destroyer_icon"; filter: "$tank_type=AT-SPG"}
			ListElement {icon: "image://gui/artillery_icon"; filter: "$tank_type=SPG"}
		}
	}
	MenuSeparator {}

	// Nation filter
	MenuHeader { text: "Filter by nation" }
	TankFilterMenuLayout {
		id: nation
		model:
		ListModel {
			ListElement {icon: "image://gui/flag_ussr_icon"; filter: "$tank_nation=ussr"}
			ListElement {icon: "image://gui/flag_germany_icon"; filter: "$tank_nation=germany"}
			ListElement {icon: "image://gui/flag_usa_icon"; filter: "$tank_nation=usa"}
			ListElement {icon: "image://gui/flag_france_icon"; filter: "$tank_nation=france"}
			ListElement {icon: "image://gui/flag_uk_icon"; filter: "$tank_nation=uk"}
			ListElement {icon: "image://gui/flag_chezch_icon"; filter: "$tank_nation=czech"}
			ListElement {icon: "image://gui/flag_china_icon"; filter: "$tank_nation=china"}
			ListElement {icon: "image://gui/flag_japan_icon"; filter: "$tank_nation=japan"}
			ListElement {icon: "image://gui/flag_poland_icon"; filter: "$tank_nation=poland"}
			ListElement {icon: "image://gui/flag_sweden_icon"; filter: "$tank_nation=sweden"}
			ListElement {icon: "image://gui/flag_italy_icon"; filter: "$tank_nation=italy"}
		}
	}
	MenuSeparator {}

	// Level filter
	MenuHeader { text: "Filter by level" }
	TankFilterMenuLayout {
		id: level
		model:
		ListModel {
			ListElement {icon: "image://gui/level_01_icon"; filter: "$tank_level=1"}
			ListElement {icon: "image://gui/level_02_icon"; filter: "$tank_level=2"}
			ListElement {icon: "image://gui/level_03_icon"; filter: "$tank_level=3"}
			ListElement {icon: "image://gui/level_04_icon"; filter: "$tank_level=4"}
			ListElement {icon: "image://gui/level_05_icon"; filter: "$tank_level=5"}
			ListElement {icon: "image://gui/level_06_icon"; filter: "$tank_level=6"}
			ListElement {icon: "image://gui/level_07_icon"; filter: "$tank_level=7"}
			ListElement {icon: "image://gui/level_08_icon"; filter: "$tank_level=8"}
			ListElement {icon: "image://gui/level_09_icon"; filter: "$tank_level=9"}
			ListElement {icon: "image://gui/level_10_icon"; filter: "$tank_level=10"}
			ListElement {icon: "image://gui/level_11_icon"; filter: "$tank_level=11"}
		}
	}
	MenuSeparator {}

	// Level filter
	MenuHeader { text: "Other filters" }
	TankFilterMenuLayout {
		id: other
		model:
		ListModel {
			ListElement {icon: "image://gui/premium_tank_icon"; filter: "$tank_premium=true"}
			ListElement {icon: "image://gui/event_tank_icon"; filter: "$tank_event=true"}
			ListElement {icon: "image://gui/3d_style_icon"; filter: "$tank_3d=true"}
			ListElement {icon: "image://gui/3d_style_progression_icon"; filter: "$tank_progression=true"}
		}
	}

	// Clear
	Button {
		text: "Clear filter"

		onClicked: {
			tankFilterMenu.clear()
			if (active) {
				context.applyQuery();
			}
		}
		Binding on enabled {
			value: tankFilterMenu.hasChecked()
		}
	}

	function hasChecked() {
		return type.hasChecked() || nation.hasChecked() || level.hasChecked() || other.hasChecked()
	}

	function clear() {
		type.clear()
		nation.clear()
		level.clear()
		other.clear()
	}
}
