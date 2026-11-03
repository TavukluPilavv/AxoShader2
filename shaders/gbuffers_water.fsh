#version 330 compatibility

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform float frameTimeCounter;
uniform float rainStrength;

in vec2 texcoord;
in vec2 lmcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
    vec2 wave = vec2(sin(texcoord.y * 31.0 + frameTimeCounter * 1.25),
                     cos(texcoord.x * 27.0 - frameTimeCounter * 0.92)) * 0.004;
    vec4 water = texture(gtexture, texcoord + wave) * glcolor;
    vec3 light = texture(lightmap, lmcoord).rgb;
    float glint = pow(max(0.0, sin(texcoord.x * 48.0 + texcoord.y * 33.0 + frameTimeCounter * 1.7)), 16.0) * 0.10;
    vec3 tint = mix(vec3(0.92, 1.02, 1.08), vec3(0.68, 0.76, 0.82), rainStrength * 0.35);
    color = vec4(water.rgb * light * tint + glint, water.a);
}
