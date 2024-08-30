import QtQuick 2.11
import QtQuick 2.11
import QtWebView 1.1

Rectangle {
	property var title: "Release Notes"

	implicitWidth: 1000
	implicitHeight: 900
	color: _palette.color7

	Accessible.name: title

	WebView {
		anchors.fill: parent
		url: context.url
	}
}
