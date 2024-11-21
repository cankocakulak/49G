// FlowField class: Generates a flow field using Perlin noise.
// Provides directional vectors for particles to follow.


class FlowField {
  PVector[] field;
  int cols, rows;
  int scl;
  
  // Control parameters
  float noiseScale = 0.1;    // Controls flow field detail:
                            // 0.05 = very smooth, gentle
                            // 0.1-0.15 = medium variation
                            // 0.2+ = chaotic, storm-like
  
  float zoff = 0;           // Controls animation speed:
                           // 0.001 = very slow
                           // 0.003 = medium
                           // 0.005+ = fast, turbulent
  
  FlowField(int w, int h, int scl) {
    this.scl = scl;
    cols = w / scl;
    rows = h / scl;
    field = new PVector[cols * rows];
    generate();
  }

  void setNoiseScale(float scale) {
    this.noiseScale = scale;
  }
  
  void setZoffIncrement(float inc) {
    this.zoff = inc;
  }

  void generate() {
    float yoff = 0;
    for (int y = 0; y < rows; y++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {
        int index = x + y * cols;
        // TWO_PI * 4 gives two complete rotations
        float angle = noise(xoff, yoff, zoff) * TWO_PI * 4;
        field[index] = PVector.fromAngle(angle);
        xoff += noiseScale;
      }
      yoff += noiseScale;
    }
    zoff += 0.003; // Base animation speed
  }

  void update() {
    generate();
  }
}