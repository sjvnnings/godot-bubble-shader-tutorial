shader_type spatial;

uniform sampler2D noise_tex;
uniform vec4 bubble_color:hint_color;
uniform float height_multiplier = 0.5;
uniform float noise_sample_size = 0.1;
uniform float animation_speed = 0.1;

varying float height;

float fresnel(vec3 normal, mat4 camera_matrix){
	vec3 view_direction_world = (camera_matrix * vec4(0.0,0.0,1.0,0.0)).xyz;
	vec3 normal_world = (camera_matrix * vec4(normal,0.0)).xyz;
	
	float d = dot(view_direction_world, normal_world);
	d = abs(d);
	d = clamp(d, 0.0, 1.0);
	
	return 1.0 - d;
}

void vertex(){
	height = texture(noise_tex, VERTEX.xz * noise_sample_size + vec2(TIME) * animation_speed).r;
	VERTEX += NORMAL * height * height_multiplier;
}

void fragment(){
	ROUGHNESS = mix(0.05, 0.1, 1.0 - height);
	SPECULAR = height;
	ALPHA = fresnel(NORMAL, CAMERA_MATRIX);
	ALBEDO = bubble_color.rgb;
}