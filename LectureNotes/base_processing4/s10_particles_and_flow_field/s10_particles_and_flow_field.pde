FlowField flowfield;
ArrayList<Particle> particles;

boolean debug = false;

void setup() {
  size(600, 600, P2D);
  
  flowfield = new FlowField(10, 0.009);
  flowfield.updateFF();
  
  initNParticles(500);
  
  background(245);
}

void draw() {
  background(245); // Comment out to see the effect
  flowfield.updateFF();
  
  if (debug) flowfield.display();
  
  for (Particle p : particles) {
    p.applyFieldForce(flowfield);
    p.run();
  }
}

// This is how we init particles 
void initNParticles(int n){
  particles = new ArrayList<Particle>();
  for (int i = 0; i < n; i++) {
    float maxSpeed = random(1, 3);
    
    if (i%2 == 0){
      PVector start_point = new PVector(random(width)/2, random(height/2));
      particles.add(new Particle(start_point, maxSpeed, 200, 0, 100));
    }
    else{
      PVector start_point = new PVector(width/2+random(width/2), height/2+random(height/2));
      particles.add(new Particle(start_point, maxSpeed, 100, 50, 200));
    }
    
  }
}
