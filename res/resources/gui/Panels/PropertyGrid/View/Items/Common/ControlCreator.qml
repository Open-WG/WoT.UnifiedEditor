import QtQuick 2.10
import QtQuick.Layouts 1.3

Item {
	id: container

	property var factory

	implicitWidth: d.item ? d.item.implicitWidth : 0
	implicitHeight: d.item ? d.item.implicitHeight : 0

	Component.onCompleted: d.alive = true
	Component.onDestruction: d.alive = false

	QtObject {
		id: d

		property Item item
		property bool alive: false
		readonly property bool needItem: alive && container.enabled

		onNeedItemChanged: {
			if (needItem) {
				item = controlsFactory.create(model, container.factory)
				item.parent = container

				if (item.hasOwnProperty("propertyRow")) {
					item.propertyRow = Qt.binding(function() { return row })
				}

				if (item.hasOwnProperty("initialize") && typeof item["initialize"] == "function") {
					item.initialize()
				}

			} else {
				if (item.hasOwnProperty("finalize") && typeof item["finalize"] == "function") {
					item.finalize()
				}

				controlsFactory.release(item)
				item = null
			}
		}
	}

	Binding {target: d.item; property: "width"; value: container.width}
	Binding {target: d.item; property: "height"; value: container.height}
}
