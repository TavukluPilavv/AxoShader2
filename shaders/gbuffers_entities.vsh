#version 330 compatibility

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform mat4 gbufferModelViewInverse;

out vec2 texcoord;
out vec2 lmcoord;
out vec4 glcolor;
out vec4 shadowPos;

void main() {
    gl_Position = ftransform();
    vec4 worldPos = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
    shadowPos = shadowProjection * shadowModelView * worldPos;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;
}
