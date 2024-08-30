import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.ControlsEx 1.0 as ControlsEx
import "Details" as Details

ControlsEx.Panel {
	title: "HIST2"
	layoutHint: "right"

	ColumnLayout {
		spacing: 10

		anchors {
			fill: parent
			topMargin: 7
			bottomMargin: 7
			leftMargin: 5
			rightMargin: 5
		}

		HistSearchToolbar {
			Layout.fillWidth: true
		}

		Details.Separator {
			Layout.fillWidth: true
		}

		HistSearch {
			Layout.fillWidth: true
		}
	}
}
