import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls 2.0 as Controls

T.ScrollView {
	id: control

	implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
	implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)

	contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : -1)
	contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : -1)

	Controls.ScrollBar.vertical: Controls.ScrollBar {
	}

	Controls.ScrollBar.horizontal: Controls.ScrollBar {
	}
}
