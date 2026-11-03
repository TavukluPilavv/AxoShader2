#version 330 compatibility

uniform vec3 skyColor;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform float rainStrength;

in vec3 skyDir;
in vec4 skyVertexColor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

float hash(vec3 p) {
    p = fract(p * 0.3183099 + vec3(0.1, 0.2, 0.3));
    p *= 17.0;
    return fract(p.x * p.y * p.z * (p.x + p.y + p.z));
}

float noise3(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec3(1,0,0));
    float c = hash(i + vec3(0,1,0));
    float d = hash(i + vec3(1,1,0));
    float e = hash(i + vec3(0,0,1));
    float g = hash(i + vec3(1,0,1));
    float h = hash(i + vec3(0,1,1));
    float j = hash(i + vec3(1,1,1));
    return mix(mix(mix(a,b,f.x),mix(c,d,f.x),f.y),
               mix(mix(e,g,f.x),mix(h,j,f.x),f.y),f.z);
}

void main() {
    vec3 dir = normalize(skyDir);
    float horizon = pow(1.0 - abs(dir.y), 3.0);
    vec3 zenith = skyColor * vec3(0.78, 0.94, 1.12);
    vec3 horizonColor = skyColor * vec3(1.08, 1.02, 0.96);
    vec3 sky = mix(zenith, horizonColor, horizon);

    vec3 sunDir = normalize(sunPosition);
    float sunDot = max(dot(dir, sunDir), 0.0);
    float disk = smoothstep(0.9992, 0.99975, sunDot);
    float halo = pow(sunDot, 24.0) * 0.18 + pow(sunDot, 90.0) * 0.26;
    vec3 sunGold = vec3(1.0, 0.78, 0.42);
    sky += sunGold * (disk * 3.2 + halo);

    // Low-cost procedural cloud veil. Soft layered noise instead of expensive raymarching.
    float cloudHeight = max(dir.y, 0.035);
    vec3 cloudP = vec3(dir.xz / cloudHeight * 1.7, 0.0);
    cloudP.x += 0.018 * cloudP.y;
    float n1 = noise3(vec3(cloudP.xy * 0.65, 0.0));
    float n2 = noise3(vec3(cloudP.xy * 1.45 + vec2(2.7, 4.1), 0.0));
    float cloudNoise = n1 * 0.68 + n2 * 0.32;
    float cloudMask = smoothstep(0.56, 0.73, cloudNoise) * smoothstep(0.02, 0.18, dir.y);
    cloudMask *= (1.0 - rainStrength * 0.25);
    vec3 cloudColor = mix(vec3(0.72, 0.79, 0.86), vec3(1.0, 0.96, 0.88), max(dot(dir, sunDir), 0.0));
    sky = mix(sky, cloudColor, cloudMask * 0.68);

    color = vec4(sky * skyVertexColor.rgb, 1.0);
}
