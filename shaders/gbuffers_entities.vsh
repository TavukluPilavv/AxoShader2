#version 330 compatibility

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

out vec2 texcoord;
out vec2 lmcoord;
out vec4 glcolor;
out vec4 shadowPos;

void main() {
    gl_Position = ftransform();
    shadowPos = shadowProjection * shadowModelView * gl_ModelViewMatrix * gl_Vertex;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;
}