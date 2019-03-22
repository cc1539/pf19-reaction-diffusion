uniform sampler2D canvas;

uniform vec2 brush_center;
uniform float brush_radius;
uniform vec4 brush_color;

vec4 getPixel(vec2 coord) {
	return texture(canvas,coord/textureSize(canvas,0));
}

void main() {
	
	vec2 offset = gl_FragCoord.xy - brush_center;
	float distance2 = dot(offset,offset);
	
	gl_FragColor = (distance2<brush_radius*brush_radius) ? brush_color : getPixel(gl_FragCoord.xy);
}
