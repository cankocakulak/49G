BouncingBall_wVect bb;

void setup(){
  size(600, 600);
  background(151);  
  
  bb = new BouncingBall_wVect();
}


void draw(){
  bb.move();
  bb.display();
}
