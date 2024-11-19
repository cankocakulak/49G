FlowField flowfield;
ArrayList<Particle> particles;

boolean isShowingFF = false;
boolean isDrawingTrace = true;

float ratioOfWhiteParticles = 1.0;
float flowFieldTimeStep = 0.007;

void setup() {
  size(1200, 800);
  
  flowfield = new FlowField(20, flowFieldTimeStep);
  flowfield.updateFF();
  
  initNParticles(10000);
  
  background(100);
}

void draw() {
  if (!isDrawingTrace) background(245);
  
  flowfield.updateFF();
  
  if (isShowingFF) flowfield.display();
  
  for (Particle p : particles) {
    p.applyFieldForce(flowfield);
    p.run();
  }
}

// This is how we init particles 
void initNParticles(int n){
  particles = new ArrayList<Particle>();
  for (int i = 0; i < n; i++) {
    float maxSpeed =random(1, 4);
    PVector start_point = new PVector(random(width), random(height));
    if (random(1)<ratioOfWhiteParticles) {
      int r = (int) random(255);
      int g = (int) random(255);
      int b = (int) random(255);
      particles.add(new Particle(start_point, maxSpeed, r, 0, 0));
    }

     else
       particles.add(new Particle(start_point, maxSpeed, 0, 0, 0));
  }
}
