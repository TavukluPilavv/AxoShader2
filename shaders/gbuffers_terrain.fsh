#version 330 compatibility

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2DShadow shadowtex0;
uniform float shadowMapResolution;

in vec2 texcoord;
in vec2 lmcoord;
in vec4 glcolor;
in vec4 shadowPos;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

float filteredShadow(vec3 p) {
    float sum = 0.0;
    float texel = 1.0 / max(shadowMapResolution, 1.0);
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            sum += texture(shadowtex0, vec3(p.xy + vec2(x, y) * texel, p.z - 0.0013));
        }
    }
    return sum / 9.0;
}

void main() {
    vec4 albedo = texture(gtexture, texcoord) * glcolor;
    if (albedo.a < 0.1) discard;
    vec3 p = shadowPos.xyz / max(shadowPos.w, 0.0001);
    p = p * 0.5 + 0.5;
    float shade = 1.0;
    if (p.x >= 0.0 && p.x <= 1.0 && p.y >= 0.0 && p.y <= 1.0 && p.z >= 0.0 && p.z <= 1.0)
        shade = filteredShadow(p);
    vec3 rgb = albedo.rgb * texture(lightmap, lmcoord).rgb;
    rgb *= mix(0.42, 1.0, shade);
    rgb = mix(rgb, rgb * vec3(1.045, 1.035, 1.02), 0.35);
    color = vec4(rgb, albedo.a);
}