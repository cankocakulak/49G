GaussianWalker3D gw;

void setup(){
  size(600, 600, P3D);
  
  gw = new GaussianWalker3D(100, 0.01);
  background(250);
  
}


void draw(){
  //translate(width/2, height/2);
  
  gw.walk();
  
  stroke(0, 75);
  fill(204, 102, 0, 50);
  point(gw.get_x(), gw.get_y(), gw.get_z());
    
  //noLoop();
}
