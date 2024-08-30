import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

T.ProgressBar {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)

    contentItem: ProgressBarImpl {
        implicitHeight: 13
        implicitWidth: 116
        scale: control.mirrored ? -1 : 1
        progress: control.position
        indeterminate: control.visible && control.indeterminate
        color: _palette.color11
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 13
        y: (control.height - height) / 2
        height: 6
		radius: 7

        color: _palette.color7
    }
}
