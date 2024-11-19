// Main program: Initializes particles, flow field, and color palette.
// Updates the flow field and particle positions each frame.
ArrayList<Particle> particles;
FlowField flowField;
Colors colors;

int scl = 20; // Scale of the flow field grid

void setup() {
  size(800, 800);
  particles = new ArrayList<Particle>();
  flowField = new FlowField(width, height, scl);
  colors = new Colors();

  for (int i = 0; i < 10000; i++) {
    particles.add(new Particle(random(width), random(height), colors));
  }

  background(255); // Set the canvas background
}

void draw() {
  flowField.update();
  
  for (Particle p : particles) {
    p.follow(flowField);
    p.update();
    p.show();
  }
}
