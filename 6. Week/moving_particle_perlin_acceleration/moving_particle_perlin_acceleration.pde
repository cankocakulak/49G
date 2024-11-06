MovingParticle mpart;
boolean stopDraw = false;

void setup() {
  size(600, 400);
  smooth();
  mpart = new MovingParticle(0,0, 0.07,0.03);
}


void draw() {
  if (!stopDraw){
    //background(255);
    
    mpart.updateAndMove();
    mpart.display();
  }
}


void keyPressed(){
  if (stopDraw){
    stopDraw = false;
  }
  else{
    stopDraw = true;
  }
}
