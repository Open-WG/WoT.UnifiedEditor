import QtQuick 2.7
import WGTools.PropertyGrid 1.0

Item {
	implicitWidth: loader.item ? loader.item.implicitWidth : 0
	implicitHeight: loader.item ? loader.item.implicitHeight : 0

	Loader {
		id: loader
		width: parent.width
		height: parent.height
		source: {
			switch (delegateRoot.mode) {
				case ColorDelegate.RGBMode: return "ColorEditRGB.qml"
				case ColorDelegate.HEXMode: return "ColorEditHEX.qml"
				case ColorDelegate.HSBMode: return "ColorEditHSB.qml"
				default: return ""
			}
		}
	}
}
