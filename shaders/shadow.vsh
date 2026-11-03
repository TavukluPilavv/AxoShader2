#version 330 compatibility

uniform float frameTimeCounter;
out vec2 texcoord;
out vec4 glcolor;

void main() {
    vec4 pos = gl_Vertex;

    // Match terrain foliage sway so leaves/grass cast moving shadows too.
    float mask = clamp((gl_Color.g - gl_Color.r) * 2.0, 0.0, 1.0);
    float phase = frameTimeCounter * 1.15 + pos.x * 1.8 + pos.z * 1.55;
    float sway = sin(phase) * 0.022 + sin(phase * 0.57 + 1.2) * 0.008;
    pos.x += sway * mask;
    pos.z += sway * 0.38 * mask;

    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    glcolor = gl_Color;
}
