import QtQuick 2.11
import WGTools.AnimSequences 1.0

Loader {
	source: switch (itemData.itemType) {
		case SequenceItemTypes.Track:
		case SequenceItemTypes.CompoundTrack:
			return "Delegates/TrackDelegate.qml"
		case SequenceItemTypes.Object:
			return "Delegates/ObjectDelegate.qml"
		default:
			return ""
	}
}
