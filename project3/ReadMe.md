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


Files and their explanations:

1. Cmpe49G_P3.pde: 
Main program file that orchestrates all components and handles user interaction.

2. Particle.pde: 
Defines how individual particles behave, move, and render on screen.

3. FlowField.pde: 
Generates a grid of vectors using Perlin noise that guides particle movement.

4. Colors.pde: 
Manages color palettes and provides dynamic color values for particles.

5. ParticlePresets.pde: 
Stores predefined configurations for different particle behaviors and effects.

6. ColorPresets.pde: 
Contains preset color schemes and their associated noise parameters.

7. FlowPresets.pde: 
Defines different flow field behaviors from gentle to chaotic movements.

