# Particle Flow System

An interactive particle system that creates various flow patterns and visual effects using Processing. This system allows users to create and manipulate particles with different behaviors, colors, and movement patterns.

## Controls

### Preset Effects
- `1` - Calm Flow: Gentle flowing particles
- `2` - Storm Flow: Intense, chaotic particle movement
- `3` - Cosmic Flow: Space-like particle patterns
- `4` - Rain: Downward falling particles
- `5` - Fountain: Upward spraying particles
- `6` - Spiral: Spiraling particle movement
- `7` - Firework: Explosive particle patterns
- `8` - Curtain: Curtain-like falling particles
- `9` - Vortex: Swirling vortex effect

### Triangle Convergence Effects
- `0` - Bottom Triangle: Particles converge from bottom to center
- `c` - Top Triangle: Particles converge from top to center
- `x` - Left Triangle: Particles converge from left to center
- `v` - Right Triangle: Particles converge from right to center

### Particle Management
- `w` - Add 500 particles
- `s` - Remove 500 particles
- `r` - Reset (clear all particles)
- `z` - Undo last action

## Features
- Multiple particle movement patterns
- Color schemes for different effects
- Particle physics simulation
- Flow field generation
- State management with undo capability
- Dynamic particle spawning and removal

## Technical Details
- Uses Perlin noise for flow field generation
- Implements particle physics with velocity and acceleration
- Features color interpolation and blending
- Supports multiple render modes (point, line, circle)
- Includes various spawn patterns (full, center, edges)

## Notes
- Performance may vary based on particle count
- Some effects work best with specific particle counts
- Color schemes are optimized for each effect type