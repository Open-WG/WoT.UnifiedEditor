import QtQuick 2.11
import QtQuick.Layouts 1.4
import "GlobalComments"

ColumnLayout {
	spacing: 0

	TimelineGlobalComments {
		Layout.fillWidth: true
	}

	TimelineSlider {
		Layout.fillWidth: true
		Layout.leftMargin: context.timelineController.leftMargin
		Layout.rightMargin: context.timelineController.rightMargin
	}
}
