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

    // Deep, dark blue-green water. Smooth directional waves (no crossed diagonal pattern).
    vec2 uv = texcoord;
    float wave1 = sin(uv.x * 32.0 + t * 1.15 + sin(uv.y * 5.0 + t * 0.25) * 1.4);
    float wave2 = sin(uv.y * 24.0 - t * 0.78 + sin(uv.x * 4.0 - t * 0.2) * 1.1);
    float wave3 = sin((uv.x * 0.72 + uv.y * 0.28) * 17.0 + t * 0.52);
    vec2 flow = vec2(wave1, wave2) * 0.0025 + vec2(wave3, -wave3) * 0.0012;

    vec4 tex = texture(gtexture, uv + flow) * glcolor;
    vec3 lm = texture(lightmap, lmcoord).rgb;

    // Low, restrained highlights on wave crests; rain suppresses reflections.
    float crest = max(wave1 * 0.55 + wave2 * 0.35 + wave3 * 0.10, 0.0);
    float highlight = pow(crest, 5.0) * 0.10 * (1.0 - rainStrength * 0.8);

    vec3 deepWater = vec3(0.035, 0.105, 0.145);
    vec3 waterTint = mix(deepWater, vec3(0.025, 0.065, 0.085), rainStrength * 0.6);
    vec3 rgb = tex.rgb * lm * waterTint * 1.65;
    rgb += vec3(0.10, 0.22, 0.28) * highlight;

    // Keep a darker underwater body and subtle moving surface sheen.
    rgb *= 0.88 + 0.12 * (0.5 + 0.5 * wave2);
    color = vec4(rgb, tex.a);
}
