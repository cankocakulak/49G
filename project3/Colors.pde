// Colors class: Manages color palettes and provides color values based on position or noise.
// Allows customization of particle colors.


class Colors {
  int[] palette;

  Colors() {
    // Define a color palette
    palette = new int[] {
      color(255, 0, 0),
      color(0, 255, 0),
      color(0, 0, 255),
      color(255, 255, 0),
      color(0, 255, 255)
    };
  }

  int getColor(float x, float y) {
    // Example: Choose a color based on position
    float n = noise(x * 0.01, y * 0.01); // Use Perlin noise for color mapping
    int index = floor(n * palette.length);
    return palette[index % palette.length];
  }
}
