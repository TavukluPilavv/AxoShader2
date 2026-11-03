#version 330 compatibility

uniform sampler2D gtexture;
uniform float frameTimeCounter;
uniform float rainStrength;

in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
    // Keep vanilla cloud texture for compatibility; add subtle depth shading.
    vec2 uv = texcoord + vec2(frameTimeCounter * 0.00135, frameTimeCounter * 0.00022);
    vec4 cloud = texture(gtexture, uv) * glcolor;
    if (cloud.a < 0.02) discard;

    float edgeShade = smoothstep(0.08, 0.92, cloud.a);
    vec3 sunlight = vec3(1.0, 0.96, 0.88);
    vec3 shadowTone = vec3(0.68, 0.74, 0.82);
    vec3 cloudColor = mix(shadowTone, sunlight, edgeShade);
    cloudColor = mix(cloudColor, vec3(0.60, 0.66, 0.73), rainStrength * 0.62);
    color = vec4(cloud.rgb * cloudColor, cloud.a);
}