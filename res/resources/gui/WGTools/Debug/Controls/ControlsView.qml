import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.11
import "Details"

Item {
	property bool debugMode: false

	implicitWidth: view.implicitWidth
	implicitHeight: view.implicitHeight

	SplitView {
		anchors.fill: parent

		Item {
			implicitWidth: view.implicitWidth
			implicitHeight: view.implicitHeight

			Layout.fillWidth: true
			Layout.fillHeight: true

			SwipeView {
				id: view
				clip: true
				anchors.fill: parent

				PageButton {}
				PageComboBox {}
				PageFilterableComboBox{}
				PageLink {}
				PageSlider {}
				PageRangeSlider {}
				PageSpinBox {}
				PageTextField {}
				PageSearchField {}
				PageCheckBox {}
				PageRadioButton {}
				PageItemDelegate {}
				PageCheckDelegate {}
				PageRadioDelegate {}
			}

			PageIndicator {
				id: indicator

				count: view.count
				currentIndex: view.currentIndex

				anchors.bottom: view.bottom
				anchors.horizontalCenter: parent.horizontalCenter
			}
		}

		Properties {
			source: view.currentItem ? view.currentItem.control : null
			Layout.fillHeight: true
		}
	}
}
