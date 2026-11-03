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
    float t = frameTimeCounter;
    // Two crossing wave fields; inexpensive UV distortion, no raymarching.
    vec2 waveA = vec2(sin(texcoord.y * 36.0 + t * 1.45),
                      cos(texcoord.x * 29.0 - t * 1.10));
    vec2 waveB = vec2(sin((texcoord.x + texcoord.y) * 52.0 - t * 1.8),
                      cos((texcoord.x - texcoord.y) * 43.0 + t * 1.35));
    vec2 distortion = (waveA * 0.65 + waveB * 0.35) * 0.006;
    vec4 water = texture(gtexture, texcoord + distortion) * glcolor;
    vec3 light = texture(lightmap, lmcoord).rgb;

    // Narrow, moving highlights imitate sun sparkles on the wave crests.
    float crest1 = sin(texcoord.x * 74.0 + texcoord.y * 31.0 + t * 2.2);
    float crest2 = sin(texcoord.y * 91.0 - texcoord.x * 28.0 - t * 1.7);
    float sparkle = pow(max(crest1 * crest2, 0.0), 7.0) * 0.20;
    sparkle *= (1.0 - rainStrength * 0.65);

    // Natural blue-green water; storm water becomes darker and less sparkly.
    vec3 tint = mix(vec3(0.72, 0.88, 0.94), vec3(0.58, 0.68, 0.72), rainStrength * 0.55);
    vec3 rgb = water.rgb * light * tint;
    rgb = mix(rgb, rgb + vec3(0.55, 0.72, 0.82) * sparkle, 0.75);
    color = vec4(rgb, water.a);
}