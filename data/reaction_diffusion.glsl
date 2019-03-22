uniform sampler2D grid;

uniform float Da;
uniform float Db;
uniform float k;
uniform float f;

float combine(vec2 value) {
	return float((int(value.x*255.)<<8)+(int(value.y*255.)))/float((1<<16)-1);
}

vec2 split(float value) {
	int scaled_value = int(value*float((1<<16)-1));
	return vec2(
		float(scaled_value>>8),
		float(scaled_value&255)
	)/255.;
}

vec2 getChemical(vec2 coord) {
	vec4 split_chem = texture(grid,coord/textureSize(grid,0));
	return vec2(combine(split_chem.xy),combine(split_chem.zw));
}

void main() {
	
	vec2 center = vec2(0.0);
	vec2 laplacian = vec2(0.0);
	for(int i=-1;i<=1;i++) {
	for(int j=-1;j<=1;j++) {
		vec2 chem = getChemical(gl_FragCoord.xy+vec2(float(i),float(j)));
		if(i==0 && j==0) {
			center = chem;
			chem *= -1.;
		} else if(i!=0 && j!=0) {
			chem *= .05;
		} else {
			chem *= .2;
		}
		laplacian += chem;
	}
	}
	
	float A = center.x;
	float B = center.y;
	float reaction = A*B*B;
	
	float new_A = A+(Da*laplacian.x-reaction+f*(1.0-A));
	float new_B = B+(Db*laplacian.y+reaction-B*(f+k));
	
	gl_FragColor = vec4(split(new_A),split(new_B));
}
