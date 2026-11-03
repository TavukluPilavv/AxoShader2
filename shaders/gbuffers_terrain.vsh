#version 330 compatibility

uniform float frameTimeCounter;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

out vec2 texcoord;
out vec2 lmcoord;
out vec4 glcolor;
out vec4 shadowPos;

void main() {
    vec4 pos = gl_Vertex;

    // Gentle leaf/grass sway, masked by green biome tint.
    float foliageMask = clamp((gl_Color.g - gl_Color.r) * 2.0, 0.0, 1.0);
    float sway = sin(frameTimeCounter * 1.25 + pos.x * 2.0 + pos.z * 1.7) * 0.018;
    pos.x += sway * foliageMask;
    pos.z += sway * 0.45 * foliageMask;

    gl_Position = gl_ModelViewProjectionMatrix * pos;
    shadowPos = shadowProjection * shadowModelView * gl_ModelViewMatrix * pos;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;
}