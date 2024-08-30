import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Templates 2.4 as T

PageIndicator {
    id: control
    count: 5
    currentIndex: 2

    delegate: T.Button {
        implicitWidth: background.implicitWidth
        implicitHeight: background.implicitHeight

        background: Rectangle {
            implicitWidth: 8
            implicitHeight: 8
            radius: width / 2
            color: "#21be2b"
            opacity: index === control.currentIndex ? 0.95 : pressed ? 0.7 : 0.45
        }

        onClicked: {
            view.currentIndex = index
        }

        ToolTip.text: view.itemAt(index).title
        ToolTip.visible: hovered
    }
}
