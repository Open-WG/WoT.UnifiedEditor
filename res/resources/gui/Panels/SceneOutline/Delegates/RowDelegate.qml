import QtQuick 2.7
import WGTools.Views.Details 1.0 as ViewDetails

ViewDetails.RowDelegate {
	id: rowDelegateRoot
	hovered: (model != undefined && typeof model["hoverRole"] != "undefined") ? (model.hoverRole) : false;

	signal hoverChanged(var index)
	signal hoverReset()

	MouseArea {
		id: rowMouseArea
		acceptedButtons: Qt.NoButton
		hoverEnabled: true
		enabled: (typeof model != "undefined") || (typeof modelData != "undefined")
		anchors.fill: parent

		Accessible.ignored: true

		onEntered: {
			// There we used some kind of hack, we calling qml rowadapter method to convert row int index to QModelIndex
			//console.log(" >>>>> MouseArea::onEntered!, model:", model, "styleData:", styleData, "index:", styleData.row)
			if (model != undefined && styleData.row != undefined) {
				rowDelegateRoot.hoverChanged(__model.mapRowToModelIndex(styleData.row))
			} else {
			 	rowDelegateRoot.hoverReset()
			}
		}

		onExited: {
			rowDelegateRoot.hoverReset()
		}
	}
}
