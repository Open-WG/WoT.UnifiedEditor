import QtQuick 2.11
import WGTools.Controls 2.0 as Controls2
import WGTools.Models 1.0

// failed search label
Controls2.Label {
	property string searchText: ""
	property alias model: itemsCounter.model
	property bool filtered: searchText.length

	horizontalAlignment: Text.AlignHCenter
	wrapMode: Text.Wrap

	text: searchText.length
		? "Your search \"" + searchText + "\" - nothing found"
		: "Nothing found"
	visible: filtered && model && itemsCounter.value == 0
		
	ModelElementsCounter {
		id: itemsCounter
		mode: ModelElementsCounter.RootChildren
	}
}
