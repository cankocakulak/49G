FlowField flowfield;
ArrayList<Particle> particles;

boolean isShowingFF = true;
boolean isDrawingTrace = true;

boolean stopDraw = false;

float ratioOfWhiteParticles = 0.99;
float flowFieldTimeStep = 0.007;

int cnt = 1;

void setup() {
  size(1200, 800);

  flowfield = new FlowField(20, flowFieldTimeStep);
  flowfield.updateFF();

  initNParticles(10000);

  background(50);
}

void draw() {
  if (!stopDraw) {
    if (!isDrawingTrace) background(245);

    if (cnt % 10 == 0) flowfield.updateFF();

    if (isShowingFF) flowfield.display();

    for (Particle p : particles) {
      p.applyFieldForce(flowfield);
      p.run();
    }
  }
}

// This is how we init particles 
void initNParticles(int n) {
  particles = new ArrayList<Particle>();
  for (int i = 0; i < n; i++) {
    float maxSpeed = random(1, 4);
    PVector start_point = new PVector(random(width), random(height));
    if (random(1)<ratioOfWhiteParticles)
      particles.add(new Particle(start_point, maxSpeed, (int)random(255), (int)random(255), (int)random(255)));
    else
      particles.add(new Particle(start_point, maxSpeed, 0, 0, 0));
  }
}


void keyPressed() {
  if (stopDraw) {
    stopDraw = false;
  } else
    stopDraw = true;
}
