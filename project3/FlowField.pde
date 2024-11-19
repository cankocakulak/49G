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

  void generate() {
    float yoff = 0;
    for (int y = 0; y < rows; y++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {
        int index = x + y * cols;
        float angle = noise(xoff, yoff) * TWO_PI;
        field[index] = PVector.fromAngle(angle);
        xoff += 0.1;
      }
      yoff += 0.1;
    }
  }

  void update() {
    generate(); // Regenerate flow field if needed (dynamic flow)
  }
}
