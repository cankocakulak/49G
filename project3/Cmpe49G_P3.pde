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


String currentPreset = "default";

void keyPressed() {
  // Preset combinations
  if (key >= '1' && key <= '5') {
    switch(key) {
      case '1': setPreset("calm"); break;
      case '2': setPreset("storm"); break;
      case '3': setPreset("cosmic"); break;
      case '4': setPreset("nature"); break;
      case '5': setPreset("fire"); break;
    }
  }
  
  // Color scheme controls
  else if (key == 'c') {
    colors.nextScheme();  // Cycle color schemes
  }
  else if (key == 'z') colors.setScheme("default");
  else if (key == 'x') colors.setScheme("sunset");
  else if (key == 'v') colors.setScheme("ocean");
  else if (key == 'b') colors.setScheme("forest");
  
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
  
  println("Current Preset: " + currentPreset + 
          " | Particles: " + particles.size() + 
          " | Flow Noise Scale: " + flowField.noiseScale +
          " | Color Scheme: " + colors.currentScheme);
}

void setPreset(String preset) {
  currentPreset = preset;
  
  switch(preset) {
    case "calm":
      // Smooth, gentle flow with ocean colors
      flowField.noiseScale = 0.05;
      flowField.zoff = 0.001;
      for (Particle p : particles) {
        p.maxSpeed = 1.5;
        p.decay = 0.98;
        p.strokeWeight = random(0.5, 1.5);
      }
      colors.setScheme("ocean");
      colors.colorNoiseScale = 0.005;
      break;
      
    case "storm":
      // Fast, chaotic movement with darker colors
      flowField.noiseScale = 0.2;
      flowField.zoff = 0.005;
      for (Particle p : particles) {
        p.maxSpeed = 4;
        p.decay = 0.95;
        p.strokeWeight = random(1, 3);
      }
      colors.setScheme("default");
      colors.colorNoiseScale = 0.02;
      break;
      
    case "cosmic":
      // Slow, dreamy movement with long trails
      flowField.noiseScale = 0.008;
      flowField.zoff = 0.002;
      for (Particle p : particles) {
        p.maxSpeed = 2;
        p.decay = 0.99;
        p.strokeWeight = random(0.3, 1);
      }
      colors.setScheme("sunset");
      colors.colorNoiseScale = 0.01;
      break;
      
    case "nature":
      // Organic, flowing movement
      flowField.noiseScale = 0.1;
      flowField.zoff = 0.003;
      for (Particle p : particles) {
        p.maxSpeed = 2.5;
        p.decay = 0.97;
        p.strokeWeight = random(1, 2);
      }
      colors.setScheme("forest");
      colors.colorNoiseScale = 0.015;
      break;
      
    case "fire":
      // Energetic, fast-moving particles
      flowField.noiseScale = 0.15;
      flowField.zoff = 0.004;
      for (Particle p : particles) {
        p.maxSpeed = 3;
        p.decay = 0.96;
        p.strokeWeight = random(1.5, 2.5);
      }
      colors.setScheme("sunset");
      colors.colorNoiseScale = 0.025;
      break;
  }
}