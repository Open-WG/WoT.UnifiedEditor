import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.ControlsEx 1.0
import WGTools.Controls.Details 2.0
import WGTools.PropertyGrid 1.0
import WGTools.Controls.impl 1.0

UVImageDelegate {
	id: delegateRoot

	property var model // TODO: consider implement context property "model"
	property var propertyRow
	property bool __enabled: propertyData && !propertyData.readonly

	propertyData: model ? model.node.property : null

	implicitWidth: image.height
	implicitHeight: image.width

	Connections {
		target: delegateRoot
		onImagePathChanged: {
			image.source = ""
			image.source = Qt.binding(function() { return delegateRoot.imagePath })
		}
		onUvRectChanged: {
			shader.uvRectCached = delegateRoot.uvRect;
			shader.u1 = shader.uvRectCached.left
			shader.v1 = shader.uvRectCached.top
			shader.u2 = shader.uvRectCached.right
			shader.v2 = shader.uvRectCached.bottom
		}
	}

	Image {
		id: image
		source: delegateRoot.imagePath
		width: parent.width / 2
		height: parent.width / 2
		visible: false
	}

	ShaderEffect {
		id: shader
		width: image.width
		height: image.height
		property var source: image
		property var uvRectCached: delegateRoot.uvRect

		property real u1: uvRectCached.left
		property real v1: uvRectCached.top
		property real u2: uvRectCached.right
		property real v2: uvRectCached.bottom

		fragmentShader: "
			uniform lowp sampler2D source;
			varying highp vec2 qt_TexCoord0;
			uniform highp float u1;
			uniform highp float v1;
			uniform highp float u2;
			uniform highp float v2;

			void main() {
				highp vec2 uv = vec2(mix(u1, u2, qt_TexCoord0.x), mix(v1, v2, qt_TexCoord0.y));
				gl_FragColor = texture2D(source, uv);
			}
		"
	}
}
