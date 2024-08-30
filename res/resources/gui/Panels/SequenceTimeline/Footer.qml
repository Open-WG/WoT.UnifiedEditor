import QtQuick 2.11
import QtQuick.Layouts 1.4
import Panels.SequenceTimeline.Timeline 1.0

Item {
	implicitHeight: layout.implicitHeight

	RowLayout {
		id: layout
		width: parent.width
		spacing: timelineSplitter.width

		Item {
			Layout.preferredWidth: timelineSplitter.x
			Layout.fillHeight: true
		}

		TimelineFooter {
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}
}
