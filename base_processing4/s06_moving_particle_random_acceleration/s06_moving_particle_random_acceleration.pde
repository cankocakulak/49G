MovingParticle mpart;

void setup() {
  size(400, 400);
  smooth();
  mpart = new MovingParticle(0,0, 0.07,0.03);
}


void draw() {
background(255);

mpart.updateAndMove();
mpart.display();
}
