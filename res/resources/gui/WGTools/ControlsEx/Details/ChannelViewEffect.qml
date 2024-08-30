import QtQuick 2.10

ShaderEffect {
	property variant source
	property double aspect;
	property double containerAspect;
	property bool redEnabled: true;
	property bool greenEnabled: true;
	property bool blueEnabled: true;
	property bool alphaEnabled: false;

	vertexShader: "
		uniform sampler2D source;
		uniform highp mat4 qt_Matrix;
		attribute highp vec4 qt_Vertex;
		attribute highp vec2 qt_MultiTexCoord0;

		varying highp vec2 coord;
		uniform lowp float aspect;
		uniform lowp float containerAspect;

		void main() {
			coord = qt_MultiTexCoord0;
			double actualAspect = aspect / containerAspect;

			if (aspect > 1.0)
			{
				coord.y = coord.y * actualAspect - 0.5f * actualAspect + 0.5f;
			}
			else
			{
				double invAspect = 1 / actualAspect;
				coord.x = coord.x * invAspect - 0.5f * invAspect + 0.5f;
			}


			gl_Position = qt_Matrix * qt_Vertex;
		}"

	fragmentShader: "
		varying highp vec2 coord;
		uniform sampler2D source;
		uniform lowp float qt_Opacity;
		uniform bool redEnabled;
		uniform bool greenEnabled;
		uniform bool blueEnabled;
		uniform bool alphaEnabled;

		void main() {
			if (coord.x < 0.0f || coord.x > 1.0f || coord.y < 0.0f || coord.y > 1.0f)
				discard;

			lowp vec4 tex = texture2D(source, coord);
			lowp vec3 multiplier = vec3(redEnabled ? 1 : 0, greenEnabled ? 1 : 0, blueEnabled ? 1 : 0);

			gl_FragColor = vec4(tex.rgb, alphaEnabled ? tex.a : 1.0f) * qt_Opacity;
			if (redEnabled && greenEnabled && blueEnabled)
				gl_FragColor = vec4(tex.rgb, alphaEnabled ? tex.a : 1.0f) * qt_Opacity;
			else if (!redEnabled && !greenEnabled && !blueEnabled && alphaEnabled)
				gl_FragColor = vec4(tex.a, tex.a, tex.a, 1.0f) * qt_Opacity;
			else if(dot(multiplier, multiplier) > 1.1f || alphaEnabled)
				gl_FragColor = vec4(vec3(tex.rgb * multiplier), alphaEnabled ? tex.a : 1.0f) * qt_Opacity;
			else
				gl_FragColor = vec4(vec3(dot(tex.rgb, multiplier)), 1.0f) * qt_Opacity;
		}"
}