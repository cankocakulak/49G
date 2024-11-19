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

  for (int i = 0; i < 10000; i++) { // Number of particles
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

void keyPressed() {
  // Color scheme controls
  if (key == ' ') {
    colors.nextScheme();  // Space bar to cycle color schemes
  } else if (key == '1') colors.setScheme("default");
  else if (key == '2') colors.setScheme("sunset");
  else if (key == '3') colors.setScheme("ocean");
  else if (key == '4') colors.setScheme("forest");
  
  // Flow field controls
  else if (key == 'q') flowField.noiseScale *= 1.1;  // Increase noise scale
  else if (key == 'a') flowField.noiseScale *= 0.9;  // Decrease noise scale
  
  // Particle controls
  else if (key == 'w') {  // Add more particles
    for (int i = 0; i < 1000; i++) {
      particles.add(new Particle(random(width), random(height), colors));
    }
  }
  else if (key == 's') {  // Remove particles
    for (int i = 0; i < 1000 && particles.size() > 0; i++) {
      particles.remove(particles.size()-1);
    }
  }
  
  // Reset
  else if (key == 'r') {  // Reset sketch
    background(255);
    particles.clear();
    for (int i = 0; i < 10000; i++) {
      particles.add(new Particle(random(width), random(height), colors));
    }
  }
  
  println("Particles: " + particles.size() + 
          " | Flow Noise Scale: " + flowField.noiseScale +
          " | Color Scheme: " + colors.currentScheme);
}
