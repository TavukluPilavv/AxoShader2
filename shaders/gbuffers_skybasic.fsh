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
    vec3 zenith = skyColor * vec3(0.72, 0.91, 1.16);
    vec3 horizonColor = skyColor * vec3(1.13, 1.03, 0.92);
    vec3 sky = mix(zenith, horizonColor, horizon);

    vec3 sunDir = normalize(sunPosition);
    float sunDot = max(dot(dir, sunDir), 0.0);
    // Defined solar disk with soft aureole and stronger warm near-sun glow.
    float disk = smoothstep(0.99935, 0.99978, sunDot);
    float corona = pow(sunDot, 18.0) * 0.20 + pow(sunDot, 65.0) * 0.42;
    float broadGlow = pow(sunDot, 7.0) * 0.075;
    vec3 sunColor = vec3(1.0, 0.82, 0.57);
    sky += sunColor * (disk * 4.0 + corona + broadGlow);

    // Three inexpensive noise layers create soft cloud volume-like depth.
    float cloudHeight = max(dir.y, 0.045);
    vec2 cloudUV = dir.xz / cloudHeight * 1.35;
    float n0 = noise3(vec3(cloudUV * 0.48, 0.0));
    float n1 = noise3(vec3(cloudUV * 0.95 + vec2(3.4, 1.7), 0.0));
    float n2 = noise3(vec3(cloudUV * 1.9 + vec2(7.1, 5.2), 0.0));
    float density = n0 * 0.58 + n1 * 0.29 + n2 * 0.13;
    float cloudMask = smoothstep(0.57, 0.76, density) * smoothstep(0.025, 0.20, dir.y);
    cloudMask *= 1.0 - rainStrength * 0.22;
    float sunFacing = max(dot(normalize(vec3(dir.x, dir.y + 0.18, dir.z)), sunDir), 0.0);
    vec3 cloudShade = mix(vec3(0.64, 0.70, 0.78), vec3(1.0, 0.94, 0.82), pow(sunFacing, 1.4));
    cloudShade *= 1.0 - rainStrength * 0.28;
    sky = mix(sky, cloudShade, cloudMask * 0.60);

    color = vec4(sky * skyVertexColor.rgb, 1.0);
}