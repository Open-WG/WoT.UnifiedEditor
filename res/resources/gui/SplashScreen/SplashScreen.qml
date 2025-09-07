import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Rectangle {
	id: window
	width: 580
	height: 380
	color: "transparent"

	FontLoader {
		id: font
		name: "Segoe UI"
	}

	Image {
		id: background
		source: ("file:///" + context.backgroundPath)
		anchors.fill: parent

		Column {
			width: parent.width - padding * 2
			anchors.bottom: parent.bottom
			padding: 40 + 20

			Image {
				id: icon
				source: ("file:///" + context.iconPath)
				width: 64
				height: 64
			}

			Rectangle {
				color: "transparent"
				width: parent.width
				height: 8
			}

			Text {
				id: productName
				text: context.name
				color: "white"
				font {
					family: font.name
					pixelSize: 16
					weight: Font.ExtraBold
				}
			}

			Rectangle {
				color: "transparent"
				width: parent.width
				height: 7
			}

			Row {
				Text {
					text: "Version "
					color: "#8C8C8C"
					font {
						family: font.name
						pixelSize: 12
					}
				}

				Text {
					text: context.version
					color: "white"
					font {
						family: font.name
						pixelSize: 12
					}
				}
			}

			Row {
				visible: context.buildTime != ""
				Text {
					text: "Built at "
					color: "#8C8C8C"
					font {
						family: font.name
						pixelSize: 12
					}
				}

				Text {
					text: context.buildTime
					color: "white"
					font {
						family: font.name
						pixelSize: 12
					}
				}
			}

			Row {
				visible: context.svnGameRevision != ""
				Text {
					text: "SVN game revision "
					color: "#8C8C8C"
					font {
						family: font.name
						pixelSize: 12
					}
				}

				Text {
					text: context.svnGameRevision
					color: "white"
					font {
						family: font.name
						pixelSize: 12
					}
				}
			}

			Row {
				visible: context.svnSourceRevision != ""
				Text {
					text: "SVN source revision "
					color: "#8C8C8C"
					font {
						family: font.name
						pixelSize: 12
					}
				}

				Text {
					text: context.svnSourceRevision
					color: "white"
					font {
						family: font.name
						pixelSize: 12
					}
				}
			}

			Row {
				visible: context.svnSourceRepo != ""
				Text {
					text: "SVN source branch "
					color: "#8C8C8C"
					font {
						family: font.name
						pixelSize: 12
					}
				}

				Text {
					text: context.svnSourceRepo
					wrapMode: Text.WordWrap
					color: "white"
					font {
						family: font.name
						pixelSize: 12
					}
				}
			}

			Rectangle {
				color: "transparent"
				width: parent.width
				height: 20
			}

			Text {
				text: context.statusMessage
				color: "white"
				font {
					family: font.name
					pixelSize: 12
				}
			}

			Rectangle {
				color: "transparent"
				width: parent.width
				height: 13
			}

			ProgressBar {
				id: control
				width: parent.width
				height: 2
				indeterminate: true

				background: Rectangle {
					color: "#084998"
				}

				contentItem: Item {
					Rectangle {
						id: bar
						width: control.visualPosition * parent.width
						height: parent.height
						color: "#0093FF"
					}
				}

				PropertyAnimation {
					target: control
					property: "value"
					from: 0
					to: 1
					duration: 3000
					running: true
					easing.type: Easing.InOutQuad
					loops: Animation.Infinite
				}
			}

			Rectangle {
				color: "transparent"
				width: parent.width
				height: 6
			}
		}
	}
}
