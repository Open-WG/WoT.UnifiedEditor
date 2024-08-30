import QtQuick 2.7
import WGTools.PropertyGrid.Unbound 1.0 as Unbound
import "Details" as Details

Unbound.AlignDelegate {
	id: delegateRoot
	property var model;

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	propertyData: model ? model.node.property : null
	enabled: propertyData && !propertyData.readOnly

	Row {
		id: layout
		spacing: 15

		anchors.centerIn: parent

		Details.UnboundAlignBox {
			id: alignSide

			Details.UnboundAlignPoint {
				id: alignToTop
				anchors.horizontalCenter: parent.horizontalCenter
				y: -Math.floor(height / 2)

				active: delegateRoot.verticalAlign == UnboundAlignDelegate.Min
				onActivate: {
					delegateRoot.verticalAlign = UnboundAlignDelegate.Min
				}
			}

			Details.UnboundAlignPoint {
				id: alignToRight
				anchors.horizontalCenter: parent.right
				anchors.verticalCenter: parent.verticalCenter

				active: delegateRoot.horizontalAlign == UnboundAlignDelegate.Max
				onActivate: {
					delegateRoot.horizontalAlign = UnboundAlignDelegate.Max
				}
			}

			Details.UnboundAlignPoint {
				id: alignToBottom
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.bottom

				active: delegateRoot.verticalAlign == UnboundAlignDelegate.Max
				onActivate: {
					delegateRoot.verticalAlign = UnboundAlignDelegate.Max
				}
			}

			Details.UnboundAlignPoint {
				id: alignToLeft
				x: -Math.floor(width / 2)
				anchors.verticalCenter: parent.verticalCenter

				active: delegateRoot.horizontalAlign == UnboundAlignDelegate.Min
				onActivate: {
					delegateRoot.horizontalAlign = UnboundAlignDelegate.Min
				}
			}
		}

		Details.UnboundAlignBox {
			id: verticalCenterAlign

			Details.UnboundAlignBox {
				width: 1
				anchors.centerIn: parent

				Details.UnboundAlignPoint {
					id: alignToVerticalCenter
					anchors.centerIn: parent

					active: delegateRoot.verticalAlign == UnboundAlignDelegate.Center
					onActivate: {
						delegateRoot.verticalAlign = UnboundAlignDelegate.Center
					}
				}
			}
		}

		Details.UnboundAlignBox {
			id: horizontalCenterAlign

			Details.UnboundAlignBox {
				height: 1
				anchors.centerIn: parent

				Details.UnboundAlignPoint {
					id: alignToHorizontalCenter
					anchors.centerIn: parent

					active: delegateRoot.horizontalAlign == UnboundAlignDelegate.Center
					onActivate: {
						delegateRoot.horizontalAlign = UnboundAlignDelegate.Center
					}
				}
			}
		}
	}
}
