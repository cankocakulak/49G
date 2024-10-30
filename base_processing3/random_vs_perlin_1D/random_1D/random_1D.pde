
int x;

float start = 0;
float t = 0;
float t_inc = 0.01;

void setup(){
  size(600, 600);
  background(51);
  
  
}



void draw(){
  stroke(255);
  background(51);
  noFill();
  
  t = start;
  
  beginShape();
  for (x=0; x<width; x++){
    // 0 point(x,300);
    // 1 point(x, random(height));
    // 2 vertex(x, random(height));
    vertex(x, noise(t)*height);
    t = t + t_inc;
  }
  endShape();
  start = start + t_inc;
  
  //noLoop();
}
