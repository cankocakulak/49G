int cols, rows;
int scl = 20;
int w = 1600;
int h = 1600;

float flying_delta_y = 0;
float flying_delta_x = 0;
float terrain_xy_inc = 0.03;

float terrain_max_height = 400;


float[][] terrain;

void setup() {
  size(800, 800, P3D);
  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];
  
  //frameRate(2);
}


void draw() {

  flying_delta_y -= 0.01;
  //flying_delta_x -= 0.005;

  float yoff = flying_delta_y;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      //terrain[x][y] = 0;// random(-10, 20);
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -0.5*terrain_max_height, terrain_max_height);
      xoff += terrain_xy_inc;
    }
    yoff += terrain_xy_inc;
  }
  
  background(0);
  stroke(255);
  noFill();

  translate(width/2, height/2);
  //translate(width/2, height/2 + 100);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  
  draw_terrain();
  
  //noLoop();
}



void draw_terrain(){
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
}
