uniform sampler2D canvas;

vec4 getPixel(vec2 coord) {
	return texture(canvas,coord/textureSize(canvas,0));
}

vec2 getGradient(vec2 coord) {
	return vec2(
		getPixel(coord+vec2(-1.0,0.0)).x-getPixel(coord+vec2(1.0,0.0)).x,
		getPixel(coord+vec2(0.0,-1.0)).x-getPixel(coord+vec2(0.0,1.0)).x
	);
}

/*
vec3 HSVtoRGB(vec3 input) {
	vec3 output = vec3(0.0);
	if(input.r<1/6.) {
		output.r = 1.0;
		output.g = input.r/(1/.6);
		output.b = 0.0;
	} else if(input.r<1/3.) {
		input.r -= 1/6.;
		output.r = 1.0-input.r/(1/.6);
		output.g = 1.0;
		output.b = 0.0;
	}
}
*/

void main() {
	vec4 chem_split = getPixel(gl_FragCoord.xy);
	vec2 chem = chem_split.xz;
	float A = chem.x;
	float B = chem.y;
	float shade = dot(getGradient(gl_FragCoord.xy),vec2(0.414,-0.414));
	gl_FragColor = vec4(vec3(A,shade,B),1.0);
}
