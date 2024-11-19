public class FlowField {
  PVector[][] vectors;
  int cols, rows;
  float grid_inc = 0.1;
  float noise_time_off = 0;
  float noise_time_inc = 0.002;
  int scl;
  
  FlowField(int res) {
    scl = res;
    cols = floor(width / res) + 1;
    rows = floor(height / res) + 1;
    vectors = new PVector[cols] [rows];
  }
  
  void updateFF() {
    float xoff = 0;
    for (int y = 0; y < rows; y++) { 
      float yoff = 0;
      for (int x = 0; x < cols; x++) {
        // Three dimentional PERLIN NOISE, 3rd component is the time component
        // So when we change noise_time_off, we look to the next snapshot of the grid
        float angle = noise(xoff, yoff, noise_time_off) * TWO_PI * 2;
        
        PVector v = PVector.fromAngle(angle);
        v.setMag(1);
        vectors[x][y] = v;
       
        xoff += grid_inc;
      }
      yoff += grid_inc;
    }
    noise_time_off += noise_time_inc;
  }
  
  
  void display() {
    for (int y = 0; y < rows; y++) { 
      for (int x = 0; x < cols; x++) {
        PVector v = vectors[x][y];
        
        stroke(0, 0, 0, 200);
        strokeWeight(0.7);
        pushMatrix();
        translate(x * scl, y * scl);
        rotate(v.heading());
        line(0, 0, scl, 0);
        popMatrix();
      }
    }
  }
}
