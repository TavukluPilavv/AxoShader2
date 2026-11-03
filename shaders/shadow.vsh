#version 330 compatibility

uniform float frameTimeCounter;
out vec2 texcoord;
out vec4 glcolor;

void main() {
    vec4 pos = gl_Vertex;
    float mask = clamp((gl_Color.g - gl_Color.r) * 2.0, 0.0, 1.0);
    float sway = sin(frameTimeCounter * 1.25 + pos.x * 2.0 + pos.z * 1.7) * 0.018;
    pos.x += sway * mask;
    pos.z += sway * 0.45 * mask;
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    glcolor = gl_Color;
}