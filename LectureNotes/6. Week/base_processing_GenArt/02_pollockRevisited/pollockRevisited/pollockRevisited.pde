float xstart, xnoise, ynoise;
void setup() {
  size(800, 800);
  smooth();
  background(0);
  xstart = random(800);
  ynoise = random(800);
  for (int y=0; y<=height; y+=1) {
    ynoise +=0.01;
    for (int x=0; x<=width; x+=1) {
      xnoise +=0.01;
      drawPollock(x, y, noise(xnoise, ynoise));
    }
  }
}

void drawPollock(float x, float y, float noiseFactor) {
  pushMatrix();
  translate(x, y);
  rotate(noiseFactor * radians(360));
  noStroke();
  fill(#A2384B);
  circle(400, 400, 1);
  fill(#F9FA47);
  circle(300, 300, 1);
  fill(0);
  circle(500, 500, 1);
  popMatrix();
}
