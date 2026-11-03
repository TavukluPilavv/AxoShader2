#version 330 compatibility

uniform sampler2D gtexture;
uniform float frameTimeCounter;
uniform float rainStrength;

in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
    // Vanilla cloud texture, gently scrolling for a moving-cloud impression.
    vec2 uv = texcoord + vec2(frameTimeCounter * 0.0018, frameTimeCounter * 0.00035);
    vec4 cloud = texture(gtexture, uv) * glcolor;
    if (cloud.a < 0.02) discard;
    vec3 shade = mix(vec3(1.0, 0.97, 0.91), vec3(0.72, 0.78, 0.86), rainStrength * 0.65);
    color = vec4(cloud.rgb * shade, cloud.a);
}
