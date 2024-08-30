import QtQuick 2.10
import QtQml.Models 2.2

Repeater {
	property alias delegate: delegateModel.delegate

	model: DelegateModel {
		id: delegateModel
		model: styleData.modelIndex != null ? styleData.group.baseModel : null;
		rootIndex: styleData.modelIndex
	}
}
