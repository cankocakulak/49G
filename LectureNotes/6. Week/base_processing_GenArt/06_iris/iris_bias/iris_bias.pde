FlowField flowfield;
Bias bias;
ArrayList<Particle> particles;
boolean isShowingFF = true;
boolean isDrawingTrace = true;
float ratioOfParticles = 0.5;
float flowFieldTimeStep = 0.007;
void setup() {
  size(700, 600, P2D);
  flowfield = new FlowField(20, flowFieldTimeStep);
  bias = new Bias(width/2, height/2, 20000);
  flowfield.updateFF();
  initNParticles(1000);
  background(40);
}
void draw() {
  if (!isDrawingTrace) background(0);
  flowfield.updateFF();
  //if (isShowingFF) flowfield.display();
  //bias.display();
  for (Particle p : particles) {
    p.applyFieldForce(flowfield);
    p.applyForce(bias.getAttractionForceOn(p).mult(-1));
    p.run();
  }
}
// This is how we init particles
void initNParticles(int n) {
  particles = new ArrayList<Particle>();
  for (int i = 0; i < n; i++) {
    float maxSpeed = random(1, 4);
    PVector start_point = new PVector(random(width/5)+2*width/5, 
      random(height/5)+2*height/5);
    float rand=random(5);
    if (rand<1) {
      particles.add(new Particle(start_point, maxSpeed, 255, 223, 211));
    } else if (rand<2) {
      particles.add(new Particle(start_point, maxSpeed, 254, 200, 216));
    } else if (rand<3) {
      particles.add(new Particle(start_point, maxSpeed, 210, 145, 188));
    } else if (rand<4) {
      particles.add(new Particle(start_point, maxSpeed, 255, 0, 0));
    } else {
      particles.add(new Particle(start_point, maxSpeed, 224, 187, 228));
    }
  }
}
