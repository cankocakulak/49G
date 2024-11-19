int cols, rows;
int scl = 20;
int w = 1200;
int h = 1200;


void setup() {
  size(800, 800, P3D);
  cols = w / scl;
  rows = h/ scl;
}


void draw() {

  background(0);
  stroke(255);
  noFill();

  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  
  draw_terrain();
  
}

void draw_terrain(){
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      //rect(x*scl, y*scl, scl, scl);
      vertex(x*scl, y*scl);
      vertex(x*scl, (y+1)*scl);
    }
    endShape();
  }
}
