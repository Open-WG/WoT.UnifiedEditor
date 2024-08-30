import QtQuick 2.10
import "../Common"
import "../Group0"
import "../Group1"

BaseGroup {
	property bool startFromZero: false;

	backgroundDelegate: RootGroupBackground {}
	headerDelegate: RootGroupHeader {}
	groupDelegate: startFromZero ? group0Component : group1Component

	Component { id: group0Component; Group0 {} }
	Component { id: group1Component; Group1 {} }
}
