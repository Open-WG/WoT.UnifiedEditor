import WGTools.Controls 2.0 as Controls

Controls.ComboBox {
	id: control

	anchors.fill: parent
	property var gameplayType: context ? context.getGameplayType(styleData.row) : null 

	onActivated: {
		tableView.model.setData(styleData.row, styleData.column, model[index])
	}
}