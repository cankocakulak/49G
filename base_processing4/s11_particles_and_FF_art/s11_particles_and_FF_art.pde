FlowField flowfield;
ArrayList<Particle> particles;

boolean isShowingFF = false;
boolean isDrawingTrace = true;

float ratioOfWhiteParticles = 0.02;
float flowFieldTimeStep = 0.007;

void setup() {
  size(1200, 800, P2D);
  
  flowfield = new FlowField(20, flowFieldTimeStep);
  flowfield.updateFF();
  
  initNParticles(10000);
  
  background(245);
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
    float maxSpeed = random(1, 4);
    
    if (i%2 == 0){
      PVector start_point = new PVector(width/2-random(width)/4, height/4+random(height/4));
      if (random(1)<ratioOfWhiteParticles)
        particles.add(new Particle(start_point, maxSpeed, 255, 255, 255));
      else
        particles.add(new Particle(start_point, maxSpeed, 200, 0, 100));
    }
    else{
      PVector start_point = new PVector(width/2+random(width/4), height/2+random(height/4));
      if (random(1)<ratioOfWhiteParticles)
        particles.add(new Particle(start_point, maxSpeed, 255, 255, 255));
      else
        particles.add(new Particle(start_point, maxSpeed, 100, 50, 200));
    }
    
  }
}
