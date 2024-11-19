// FlowField class: Generates a flow field using Perlin noise.
// Provides directional vectors for particles to follow.


class FlowField {
  PVector[] field;
  int cols, rows;
  int scl;

  FlowField(int w, int h, int scl) {
    this.scl = scl;
    cols = w / scl;
    rows = h / scl;
    field = new PVector[cols * rows];
    generate();
  }

  // Add new parameters for noise control
  float noiseScale = 0.1;    // Smaller = smoother flow, larger = more chaotic
  float zoff = 0;            // Controls flow animation

  void generate() {
    float yoff = 0;
    for (int y = 0; y < rows; y++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {
        int index = x + y * cols;
        // Add z-dimension for animation
        float angle = noise(xoff, yoff, zoff) * TWO_PI * 4; // Multiply by 4 for more rotation
        field[index] = PVector.fromAngle(angle);
        xoff += noiseScale;
      }
      yoff += noiseScale;
    }
    zoff += 0.003; //  Speed of field animation
  }

  void update() {
    generate(); // Regenerate flow field if needed (dynamic flow)
  }
}
