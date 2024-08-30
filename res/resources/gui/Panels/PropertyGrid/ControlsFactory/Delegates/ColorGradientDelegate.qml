import QtQuick 2.11
import QtGraphicalEffects 1.0
import WGTools.PropertyGrid 1.0

ColorGradientDelegate {
	id: delegateRoot
	property var model // TODO: consider implement context property "model"

	implicitHeight: 20
	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readOnly

	Accessible.name: "Gradient"

	LinearGradient {
		id: linearGradient

		width: parent.width
		height: parent.height

		start: Qt.point(0, 0)
		end: Qt.point(delegateRoot.width, 0)

		function setStops(stops) {
			// Note: To apply added or removed stops to gradient you have to reassign whole gradient property.
			gradient = null;
			gradientProxy.stops = stops;
			gradient = gradientProxy;
		}

		Gradient {
			id: gradientProxy

			readonly property var __instantiator: Instantiator {
				property var gradientStops: []

				model: delegateRoot.gradientModel
				delegate: GradientStop {
					position: model.position;
					color: model.color
				}
				onObjectAdded: {
					gradientStops.splice(index, 0, object);
					linearGradient.setStops(gradientStops);
				}
				onObjectRemoved: {
					var stopIndex = gradientStops.indexOf(object);
					gradientStops.splice(stopIndex, 1);
					linearGradient.setStops(gradientStops);
				}
			}
		}

		MouseArea {
			id: mouseArea
			property bool clicked: false

			anchors.fill: parent
			onClicked: {
				if (!clicked) {
					delegateRoot.invokeButtonEvent();
					timer.start()
					clicked = true;
				}
			}

			// to prevent multiple fires...
			Timer {
				id: timer
				interval: 300
				onTriggered: mouseArea.clicked = false
			}
		}
	}
}
