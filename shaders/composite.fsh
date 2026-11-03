#version 330 compatibility

uniform sampler2D colortex0;

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
    color = texture(colortex0, texcoord);

    // Subtle warm daylight grading; intentionally light to preserve FPS.
    vec3 warm = vec3(1.025, 1.012, 0.985);
    color.rgb = mix(color.rgb, color.rgb * warm, 0.22);
}
