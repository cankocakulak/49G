MovingParticle_Acc2Mouse mpart;

void setup() {
  size(400, 400);
  smooth();
  mpart = new MovingParticle_Acc2Mouse(0,0, 0,0);
}


void draw() {
background(255);

mpart.update();
mpart.display();
}
