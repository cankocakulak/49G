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
  if (key >= '1' && key <= '6') {
    switch(key) {
      case '1': setPreset("calm"); break;
      case '2': setPreset("storm"); break;
      case '3': setPreset("cosmic"); break;
      case '4': setPreset("nature"); break;
      case '5': setPreset("fire"); break;
      case '6': setPreset("mountains"); break;
    }
  }
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
    resetSketch();
  }
  
  println("Current Preset: " + currentPreset + 
          " | Particles: " + particles.size() + 
          " | Flow Noise Scale: " + flowField.noiseScale +
          " | Color Scheme: " + colors.currentScheme);
}

void resetSketch() {
  background(255);
  particles.clear();
  for (int i = 0; i < 10000; i++) {
    particles.add(new Particle(random(width), random(height), colors));
  }
}

// Define preset parameters as a class
class PresetParams {
  float flowNoiseScale, flowZoff;
  float particleMaxSpeed, particleDecay, particleStrokeWeight;
  float colorNoiseScale;
  String colorScheme;
  
  PresetParams(float fns, float fz, float pms, float pd, float psw, float cns, String cs) {
    flowNoiseScale = fns;
    flowZoff = fz;
    particleMaxSpeed = pms;
    particleDecay = pd;
    particleStrokeWeight = psw;
    colorNoiseScale = cns;
    colorScheme = cs;
  }
}

// Store all presets in a HashMap
HashMap<String, PresetParams> presets = new HashMap<String, PresetParams>() {{
  put("calm", new PresetParams(
    0.05,   // flowNoiseScale
    0.001,  // flowZoff
    1.5,    // particleMaxSpeed
    0.98,   // particleDecay
    1.0,    // particleStrokeWeight
    0.005,  // colorNoiseScale
    "ocean" // colorScheme
  ));
  
  put("storm", new PresetParams(
    0.2, 0.005, 4.0, 0.95, 2.0, 0.02, "default"
  ));
  
  put("cosmic", new PresetParams(
    0.008, 0.002, 2.0, 0.99, 0.7, 0.01, "sunset"
  ));
  
  put("nature", new PresetParams(
    0.1, 0.003, 2.5, 0.97, 1.5, 0.015, "forest"
  ));
  
  put("fire", new PresetParams(
    0.15, 0.004, 3.0, 0.96, 2.0, 0.025, "sunset"
  ));
  
  put("mountains", new PresetParams(
    10000.6, 0.0015, 1.8, 0.985, 0.8, 11.12, "mountain"
  ));
}};

void setPreset(String preset) {
  currentPreset = preset;
  
  PresetParams params = presets.get(preset);
  if (params == null) return;
  
  // Apply configurations
  flowField.setNoiseScale(params.flowNoiseScale);
  flowField.setZoffIncrement(params.flowZoff);
  
  for (Particle p : particles) {
    p.setProperties(
      params.particleMaxSpeed,
      params.particleDecay,
      random(params.particleStrokeWeight * 0.5, params.particleStrokeWeight * 1.5)
    );
  }
  
  colors.setScheme(params.colorScheme);
  colors.setColorNoiseScale(params.colorNoiseScale);
}


  
  /*
  // Color scheme controls
  else if (key == 'c') colors.nextScheme();  // Cycle color schemes
  else if (key == 'z') colors.setScheme("default");
  else if (key == 'x') colors.setScheme("sunset");
  else if (key == 'v') colors.setScheme("ocean");
  else if (key == 'b') colors.setScheme("forest");
  
  // Flow field controls
  else if (key == 'q') flowField.noiseScale *= 1.1;  // Increase noise scale
  else if (key == 'a') flowField.noiseScale *= 0.9;  // Decrease noise scale
  

  */
