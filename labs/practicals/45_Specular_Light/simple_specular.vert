#version 440

// The model matrix
uniform mat4 M;
// The transformation matrix
uniform mat4 MVP;
// The normal matrix
uniform mat3 N;
// Material colour
uniform vec4 material_colour;
// Shininess of the object
uniform float shininess;
// Light colour
uniform vec4 light_colour;
// Direction of the light
uniform vec3 light_dir;
// Position of the camera
uniform vec3 eye_pos;

// Incoming position
layout(location = 0) in vec3 position;
// Incoming normal
layout(location = 2) in vec3 normal;

// Outgoing vertex colour
layout(location = 0) out vec4 vertex_colour;

void main() {
  // *********************************
  // Calculate position
  gl_Position = MVP * vec4(position, 1.0);
  // Transform the normal
    vec3 transformed_normal = N * normal;
  // Calculate world position
  vec3 worldpos = vec3(M * vec4(position, 1.0));
  // Calculate view direction
  vec3 viewdirr = normalize(eye_pos - worldpos);
  // Calculate half vector between view_dir and light_dir
  vec3 hvec = normalize(light_dir + viewdirr);
  // Calculate k
    float k = pow(max(dot(transformed_normal, hvec), 0.0), shininess);
  // Calculate specular
  vec4 specular = k * (material_colour * light_colour);
  // Ensure alpha is 1
  specular.a = 1.0;
  // Output vertex colour - just diffuse
  vertex_colour = specular;
  // *********************************
}