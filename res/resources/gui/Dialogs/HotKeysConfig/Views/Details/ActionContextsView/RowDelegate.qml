import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Views.Details 1.0 as ViewsDetails

Control {
	id: control
	height: ViewsSettings.rowDelegateHeight
	background: ViewsDetails.RowDelegate {
		hovered: control.hovered
	}
}
