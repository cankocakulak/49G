MovingParticle mpart;

FixedAttractor fa1;
FixedAttractor fa2;

void setup() {
  size(900, 900);
  smooth();
  mpart = new MovingParticle(600,250,  0.6,0,  0,0,  16);
  fa1 = new FixedAttractor(630, height/2, 64);
  fa2 = new FixedAttractor(10, height/2, 64);
}


void draw() {
// background(235); // you may uncomment to see the effect

PVector attraction_force1 = fa1.getAttractionForceOn(mpart);
PVector attraction_force2 = fa2.getAttractionForceOn(mpart);

mpart.applyForce(attraction_force1);
mpart.applyForce(attraction_force2);
mpart.update();

mpart.display();
fa1.display();
fa2.display();
}
