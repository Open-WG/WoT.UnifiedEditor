import QtQuick 2.10
import WGTools.ControlsEx.Details 1.0 as Details
import WGTools.Misc 1.0 as Misc

Item {
	property alias source: img.source
	property alias effect: effect
	property alias image: img
	property bool isLoading: img.status == Image.Loading
	property bool isReady: img.status == Image.Ready
	
	implicitWidth: img.implicitWidth
	implicitHeight: img.implicitHeight

	Image {
		id: img
		width: parent.width
		height: parent.height
		fillMode: Image.PreserveAspectFit
		verticalAlignment: Image.AlignVCenter
		horizontalAlignment: Image.AlignHCenter
		visible: effect.visible
		cache : false
		asynchronous: true
	}

	Details.ChannelViewEffect {
		id: effect
		width: img.width;
		height: img.height;
		source: img
		visible: redEnabled || greenEnabled || blueEnabled || alphaEnabled
		anchors.centerIn: img
		
		function getAspect(size)
		{	
			if(size.width == 0 || size.height == 0)
			{
				return 1.0
			}

			return size.width/size.height
		}
			
		aspect: getAspect(img.sourceSize)
		containerAspect: img.width/img.height
	}
}
