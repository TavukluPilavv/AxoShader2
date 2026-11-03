#version 330 compatibility

uniform float frameTimeCounter;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform mat4 gbufferModelViewInverse;

out vec2 texcoord;
out vec2 lmcoord;
out vec4 glcolor;
out vec4 shadowPos;

void main() {
    vec4 pos = gl_Vertex;

    // Subtle synchronized foliage sway. Green-biome vertex tint is a lightweight mask.
    float foliageMask = clamp((gl_Color.g - gl_Color.r) * 2.0, 0.0, 1.0);
    float phase = frameTimeCounter * 1.15 + pos.x * 1.8 + pos.z * 1.55;
    float sway = sin(phase) * 0.022 + sin(phase * 0.57 + 1.2) * 0.008;
    pos.x += sway * foliageMask;
    pos.z += sway * 0.38 * foliageMask;

    gl_Position = gl_ModelViewProjectionMatrix * pos;

    // Transform camera-space vertex back to world space before shadow projection.
    vec4 worldPos = gbufferModelViewInverse * gl_ModelViewMatrix * pos;
    shadowPos = shadowProjection * shadowModelView * worldPos;

    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;
}
