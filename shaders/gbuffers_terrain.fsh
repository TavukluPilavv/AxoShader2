#version 330 compatibility

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2DShadow shadowtex0;

in vec2 texcoord;
in vec2 lmcoord;
in vec4 glcolor;
in vec4 shadowPos;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

float getShadow() {
    vec3 projected = shadowPos.xyz / max(shadowPos.w, 0.0001);
    projected = projected * 0.5 + 0.5;
    if (projected.x < 0.0 || projected.x > 1.0 ||
        projected.y < 0.0 || projected.y > 1.0 ||
        projected.z < 0.0 || projected.z > 1.0) return 1.0;

    // Small depth bias helps reduce self-shadowing.
    return texture(shadowtex0, vec3(projected.xy, projected.z - 0.0015));
}

void main() {
    vec4 albedo = texture(gtexture, texcoord) * glcolor;
    if (albedo.a < 0.1) discard;

    vec4 lit = albedo * texture(lightmap, lmcoord);
    float shadow = getShadow();
    lit.rgb *= mix(0.48, 1.0, shadow);
    color = lit;
}