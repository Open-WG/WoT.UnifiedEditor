import QtQuick 2.11
import WGTools.Style 1.0

Item {
	id: contentItem
	
	Image {
		id: image
		width: parent.width
		height: width
		verticalAlignment: Image.AlignVCenter
		horizontalAlignment: Image.AlignHCenter
		fillMode: Image.PreserveAspectFit
		asynchronous: true
		cache: false
		smooth: true

		source: model.texture
			? model.palette.length != 0
				? "image://camouflagePreview/" + model.texture +
				"?imageIndex=" + model.display +
				"&R=" + encodeURIComponent(model.palette[0]) +
				"&G=" + encodeURIComponent(model.palette[1]) + 
				"&B=" + encodeURIComponent(model.palette[2]) + 
				"&A=" + encodeURIComponent(model.palette[3])
				: "image://gui/" + model.texture
			: ""
	}

	Text {
		width: parent.width
		y: image.height + control.spacing
		leftPadding: 5
		rightPadding: 5

		text: model.display
		horizontalAlignment:Text.AlignHCenter
		elide: Text.ElideRight
		clip: true

		Style.class: "text-base"
	}
}
