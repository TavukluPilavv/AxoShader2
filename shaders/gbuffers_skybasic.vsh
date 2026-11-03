#version 330 compatibility

out vec3 skyDir;
out vec4 skyVertexColor;

void main() {
    gl_Position = ftransform();
    skyDir = gl_Vertex.xyz;
    skyVertexColor = gl_Color;
}
