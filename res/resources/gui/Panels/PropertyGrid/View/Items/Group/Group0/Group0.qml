import QtQuick 2.10
import "../Group1"

Group1 {
	headerDelegate: Group0Header {
		text: model ? model.node.name : ""
	}

	groupDelegate: Group1 {}
}
