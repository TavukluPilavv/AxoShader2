# AxoShader2

A Minecraft Java 1.21.1 Iris shader pack prototype.

## Current additions
- Vanilla-lightmap-preserving terrain/entity baseline
- Sky gradient with warm sun disk and glow
- Lightweight procedural cloud-like noise in the sky
- Animated vanilla cloud UV pass
- Animated water UV ripples and small highlights
- Shadow caster pass with alpha testing for leaves
- 1024 shadow-map target to favor performance

## Planned
- Complete shadow-map sampling/composite (tree, terrain, player and mob shadows)
- More physically convincing cloud layers and sun glare
- Better foliage/grass animation restricted to actual foliage
- Real water reflections/refraction and wave normals
- Performance presets

## Install
1. Install Iris for Minecraft Java 1.21.1.
2. Download the `AxoShader2` artifact from GitHub Actions.
3. Place ZIP in `.minecraft/shaderpacks`.
4. Select it in Iris.

## Test status
This is still experimental. The newly added sky/cloud/water/shadow files have not been compiled or tested in Minecraft yet. Some visual effects may need fixes after testing. The current water effect is a simple animated UV ripple, not physically realistic reflections. The shadow caster is present, but full screen-space shadow application still needs a proper tested composite.
