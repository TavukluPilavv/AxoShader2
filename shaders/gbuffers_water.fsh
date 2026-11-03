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
    vec2 uv = texcoord;

    // Broad, flowing wave shapes; avoid the old tight crossing/diagonal ripples.
    float waveA = sin(uv.x * 17.0 + t * 0.72 + sin(uv.y * 3.5 + t * 0.18) * 1.25);
    float waveB = sin(uv.y * 13.0 - t * 0.48 + sin(uv.x * 2.8 - t * 0.16) * 1.05);
    float waveC = sin((uv.x * 0.8 + uv.y * 0.2) * 8.0 + t * 0.35);
    vec2 flow = vec2(waveA, waveB) * 0.0035 + vec2(waveC, -waveC) * 0.001;

    vec4 tex = texture(gtexture, uv + flow) * glcolor;
    vec3 light = texture(lightmap, lmcoord).rgb;

    // Deep ocean blue with only a small contribution from the vanilla texture
    // to reduce its busy diagonal-looking pattern.
    vec3 deep = mix(vec3(0.018, 0.065, 0.105), vec3(0.012, 0.038, 0.060), rainStrength * 0.65);
    vec3 textureColor = tex.rgb * light * vec3(0.12, 0.30, 0.42);
    vec3 rgb = mix(deep, textureColor, 0.20);

    // Slow, wide moving wave highlights. Much less glitter than the previous version.
    float crest = max(waveA * 0.62 + waveB * 0.30 + waveC * 0.08, 0.0);
    float highlight = pow(crest, 4.0) * 0.075 * (1.0 - rainStrength * 0.82);
    rgb += vec3(0.075, 0.16, 0.21) * highlight;

    // Slight brightness variation makes the surface visibly move.
    rgb *= 0.92 + 0.08 * (0.5 + 0.5 * waveB);
    color = vec4(rgb, tex.a);
}
