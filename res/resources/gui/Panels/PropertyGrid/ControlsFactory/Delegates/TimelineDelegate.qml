import QtQuick 2.7
import QtQuick.Layouts 1.3
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc

import "Details/Timeline" as Details
import "Settings.js" as Settings

TimelineDelegate {
	id: delegateRoot

	property var model // TODO: consider implement context property "model"

	implicitWidth: timeline.implicitWidth
	implicitHeight: layout.implicitHeight
	propertyData: model ? model.node.property : null

	enabled: propertyData && !propertyData.readonly

	ColumnLayout {
		id: layout
		width: parent.width

		Details.Timeline {
			id: timeline

			scale: delegateRoot != null ? delegateRoot.scale : null

			Layout.fillWidth: true
		}

		RowLayout {
			Layout.fillWidth: true

			ColumnLayout {
				id: startDurColumn

				Misc.Text {
					id: startText

					Layout.fillHeight: true

					text: "Start Frame:"

					verticalAlignment: Text.AlignVCenter
				}

				Misc.Text {
					id: durationText

					Layout.fillHeight: true

					text: "Duration:"

					verticalAlignment: Text.AlignVCenter
				}
			}

			ColumnLayout {
				Layout.maximumWidth: layout.width / 2 - startDurColumn.width

				DoubleSpinBox {
					Layout.fillWidth: true

					Binding on value {
						value: delegateRoot.start
					}

					from: 0
					to: delegateRoot.end

					inputMethodHints: Qt.ImhDigitsOnly
					decimals: 0

					onValueModified: {
						delegateRoot.setStart(value, false)
					}
				}

				Misc.Text {
					Layout.fillWidth: true

					enabled: false

					text: getText()
					elide: Text.ElideRight

					function getText() {
						return (delegateRoot.duration / delegateRoot.sampleRate).toFixed(3) + "s (" +
							delegateRoot.duration + "f)"
					}
				}
			}

			ColumnLayout {
				id: endSampleColumn

				Misc.Text {
					id: endText

					Layout.fillHeight: true

					text: "End Frame:"

					verticalAlignment: Text.AlignVCenter
				}

				Misc.Text {
					id: sampleRateText

					Layout.fillHeight: true

					text: "Sample Rate:"

					verticalAlignment: Text.AlignVCenter
				}
			}

			ColumnLayout {
				Layout.maximumWidth: layout.width / 2 - endSampleColumn.width

				DoubleSpinBox {
					Layout.fillWidth: true

					Binding on value {
						value: delegateRoot.end
					}

					from: delegateRoot.start
					to: delegateRoot.maxEnd

					inputMethodHints: Qt.ImhDigitsOnly
					decimals: 0

					onValueModified: {
						delegateRoot.setEnd(value, false)
					}
				}

				Misc.Text {
					Layout.fillWidth: true

					text: delegateRoot.sampleRate
					elide: Text.ElideRight
				}
			}
		}
	}
}
