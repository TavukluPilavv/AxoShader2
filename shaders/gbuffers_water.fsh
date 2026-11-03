#version 330 compatibility

uniform sampler2D gtexture;
uniform sampler2D lightmap;

in vec2 texcoord;
in vec2 lmcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
    vec4 water = texture(gtexture, texcoord) * glcolor;
    vec3 light = texture(lightmap, lmcoord).rgb;
    color = vec4(water.rgb * light, water.a);
}
