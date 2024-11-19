
LatticeWalker2D w;

void setup(){
  size(600, 600);
  
  w = new LatticeWalker2D(4);
  background(255);
  
}


void draw(){
  w.walk();
  w.render();
  //noLoop();
}
