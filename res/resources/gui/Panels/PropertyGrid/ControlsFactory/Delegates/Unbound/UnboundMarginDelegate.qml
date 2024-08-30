import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import WGTools.PropertyGrid 1.0
import WGTools.PropertyGrid.Unbound 1.0 as Unbound
import "Details" as Details

Unbound.MarginDelegate {
	id: delegateRoot
	property var model; // TODO: consider implement context property "model"
	propertyData: model ? model.node.property : null;
	enabled: propertyData && !propertyData.readonly

	implicitWidth: marginRect.implicitWidth
	implicitHeight: marginRect.implicitHeight

	Layout.fillWidth: true // grid layouting rule

	Rectangle {
		id: marginRect

		color: _palette.color8

		implicitHeight: 136
		width: parent.width

		Details.UnboundMarginHeader {
			text: "Margins"
		}

		Rectangle {
			id: paddingRect

			color: _palette.color7
			anchors.centerIn: marginRect
			width: marginRect.width / 2
			height: marginRect.height / 2

			Details.UnboundMarginHeader {
				text: "Paddings"
			}

			Details.UnboundMarginHeader {
				text: "Content"
				anchors.centerIn: paddingRect
				anchors.margins: 0
			}

			Details.UnboundMarginLabel {
				typedNumber: paddingLeft
				anchors.left: paddingRect.left
				anchors.leftMargin: 10
				anchors.verticalCenter: parent.verticalCenter
			}

			Details.UnboundMarginLabel {
				typedNumber: paddingTop
				anchors.top: paddingRect.top
				anchors.topMargin: 3
				anchors.horizontalCenter: parent.horizontalCenter
			}

			Details.UnboundMarginLabel {
				typedNumber: paddingRight
				anchors.right: paddingRect.right
				anchors.rightMargin: 10
				anchors.verticalCenter: parent.verticalCenter
			}

			Details.UnboundMarginLabel {
				typedNumber: paddingBottom
				anchors.bottom: paddingRect.bottom
				anchors.bottomMargin: 3
				anchors.horizontalCenter: parent.horizontalCenter
			}
		}

		Details.UnboundMarginLabel {
			typedNumber: marginLeft
			x: (marginRect.width - paddingRect.width) / 4 - width / 2
			anchors.verticalCenter: parent.verticalCenter
		}

		Details.UnboundMarginLabel {
			typedNumber: marginTop
			y: (marginRect.height - paddingRect.height) / 4 - height / 2
			anchors.horizontalCenter: parent.horizontalCenter
		}

		Details.UnboundMarginLabel {
			typedNumber: marginRight
			x: marginRect.width - (marginRect.width - paddingRect.width) / 4 - width / 2
			anchors.verticalCenter: parent.verticalCenter
		}

		Details.UnboundMarginLabel {
			typedNumber: marginBottom
			y: marginRect.height - (marginRect.height - paddingRect.height) / 4 - height / 2
			anchors.horizontalCenter: parent.horizontalCenter
		}
	}
}
