import QtQuick 2.11
import QtQuick.Layouts 1.4
import "../Buttons"

Item {
	property alias curveView: fitToButton.curveView

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	RowLayout {
		id: layout
		width: Math.min(parent.width, implicitWidth)
		height: parent.height
		spacing: 10

		RowLayout {
			spacing: 1
			SequenceAddButton {}
			SequenceOpenButton {}
			SequenceSaveButton {}
		}

		FitToButton { id: fitToButton }
		CurveModeButton {}
		GizmoButton {}
	}
}
