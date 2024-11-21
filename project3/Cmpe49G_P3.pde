// Main program: Initializes particles, flow field, and color palette.
ArrayList<Particle> particles;
FlowField flowField;
Colors colors;
String currentPreset = "default";
import java.util.Iterator;


int scl = 20; // Scale of the flow field grid

void setup() {
  size(800, 800);
  particles = new ArrayList<Particle>();  // Start empty
  flowField = new FlowField(width, height, scl);
  colors = new Colors();
  background(255);
}

void setPreset(String preset) {
  ScenePreset scene = scenePresets.get(preset);
  if (scene == null) return;
  
  currentPreset = preset;
  
  // Apply configurations without creating particles
  ParticlePreset pp = particlePresets.get(scene.particlePreset);
  FlowPreset fp = flowPresets.get(scene.flowPreset);
  ColorPreset cp = colorPresets.get(scene.colorPreset);
  
  if (pp == null || fp == null || cp == null) return;
  
  // Only update system settings
  flowField.setNoiseScale(fp.noiseScale);
  flowField.setZoffIncrement(fp.zoff);
  colors.setScheme(cp.scheme);
  colors.setColorNoiseScale(cp.noiseScale);
  
  // Clear existing particles
  particles.clear();
  
  // Print the new state
  println("Switched to preset: " + preset + " (0 particles)");
}

void draw() {
  flowField.update();
  
  // Create temporary lists for modifications
  ArrayList<Particle> particlesToAdd = new ArrayList<Particle>();
  ArrayList<Particle> particlesToRemove = new ArrayList<Particle>();
  
  // First pass: update and mark particles for removal
  for (Particle p : particles) {
    if (p.movementMode.equals("flow")) {
      p.follow(flowField);
    }
    
    p.update();
    
    if (p.lifespan < 1) {
      particlesToRemove.add(p);
      
      // Queue new particle for addition
      ParticlePreset pp = particlePresets.get(currentPreset);
      if (pp != null) {
        PVector pos = getSpawnPosition(pp.spawnPattern);
        Particle newP = new Particle(
          pos.x, pos.y,
          colors,
          pp.renderMode,
          pp.movementMode
        );
        newP.setProperties(pp.maxSpeed, pp.decay, pp.strokeWeight);
        particlesToAdd.add(newP);
      }
    }
    
    p.show();
  }
  
  // After iteration: perform removals and additions
  particles.removeAll(particlesToRemove);
  particles.addAll(particlesToAdd);
}



void keyPressed() {
  if (key >= '1' && key <= '9') {
    switch(key) {
      case '1': setPreset("calm_flow"); break;
      case '2': setPreset("storm_flow"); break;
      case '3': setPreset("cosmic_flow"); break;
      case '4': setPreset("rain"); break;
      case '5': setPreset("fountain"); break;
      case '6': setPreset("spiral"); break;
      case '7': setPreset("firework"); break;
      case '8': setPreset("curtain"); break;
      case '9': setPreset("vortex"); break;
    }
  }
  
  else if (key == 'w') {  // Add particles
    ScenePreset scene = scenePresets.get(currentPreset);
    if (scene != null) {
      ParticlePreset pp = particlePresets.get(scene.particlePreset);
      if (pp != null) {
        // Add particles in smaller batches
        int batchSize = 500;  // Add 500 particles at a time
        for (int i = 0; i < batchSize; i++) {
          PVector pos = getSpawnPosition(pp.spawnPattern);
          Particle p = new Particle(pos.x, pos.y, colors, pp.renderMode, pp.movementMode);
          p.setProperties(pp.maxSpeed, pp.decay, pp.strokeWeight);
          
          // Special initialization for certain modes
          if (pp.movementMode.equals("fountain")) {
            p.vel = new PVector(random(-2, 2), -random(8, 12));
          }
          
          particles.add(p);
        }
        println("Added " + batchSize + " particles. Total: " + particles.size());
      }
    }
  }
  
  else if (key == 's') {  // Remove particles
    int removeCount = min(500, particles.size());  // Remove 500 at a time
    for (int i = 0; i < removeCount; i++) {
      particles.remove(particles.size()-1);
    }
    println("Removed " + removeCount + " particles. Total: " + particles.size());
  }
  
  else if (key == 'r') {  // Reset to empty
    particles.clear();
    background(255);
    println("Reset to 0 particles");
  }
  
  printState();
}

// Updated scene presets with consistent naming
HashMap<String, ScenePreset> scenePresets = new HashMap<String, ScenePreset>() {{
  // Flow-based scenes
  put("calm_flow", new ScenePreset(
    "calm",         // flow preset
    "sparse_flow",  // particle preset
    "ocean_calm"    // color preset
  ));
  
  put("storm_flow", new ScenePreset(
    "storm",
    "dense_flow",
    "sunset_dynamic"
  ));
  
  put("cosmic_flow", new ScenePreset(
    "cosmic",
    "fine_flow",
    "sunset_dynamic"
  ));
  
  // Special effect scenes
  put("rain", new ScenePreset(
    "gentle",       // gentle downward flow
    "rain_effect",  // rain particles
    "ocean_calm"    // blue-ish colors
  ));
  
  put("fountain", new ScenePreset(
    "gentle",           // gentle flow
    "fountain_effect",  // fountain particles
    "forest_deep"       // green colors
  ));


  put("spiral", new ScenePreset(
    "swirly",          // swirling flow
    "spiral_effect",   // spiral particles
    "sunset_dynamic"   // warm colors
  ));
  
  put("firework", new ScenePreset(
    "explosive",
    "firework_effect",
    "sunset_dynamic"
  ));
  
  put("curtain", new ScenePreset(
    "downward",
    "curtain_effect",
    "ocean_calm"
  ));
  
  put("vortex", new ScenePreset(
    "spiral",
    "vortex_effect",
    "cosmic_dark"
  ));
}};

void resetSketch() {
  background(255);
  particles.clear();
  
  ParticlePreset pp = particlePresets.get(currentPreset);
  if (pp == null) return;
  
  for (int i = 0; i < pp.count; i++) {
    PVector pos = getSpawnPosition(pp.spawnPattern);
    Particle p = new Particle(pos.x, pos.y, colors, pp.renderMode, pp.movementMode);
    p.setProperties(pp.maxSpeed, pp.decay, pp.strokeWeight);
    particles.add(p);
  }
}



PVector getSpawnPosition(String pattern) {
  switch(pattern) {
    case "full":
      return new PVector(random(width), random(height));
    case "center":
      float angle = random(TWO_PI);
      float radius = random(50);
      return new PVector(width/2 + cos(angle) * radius, height/2 + sin(angle) * radius);
    case "top":
      return new PVector(random(width), 0);
    case "bottom":
      return new PVector(random(width), height);
    case "sides":
      return new PVector(random(1) < 0.5 ? 0 : width, random(height));
    default:
      return new PVector(random(width), random(height));
  }
}

void printState() {
  ScenePreset scene = scenePresets.get(currentPreset);
  if (scene == null) return;
  
  ParticlePreset pp = particlePresets.get(scene.particlePreset);
  FlowPreset fp = flowPresets.get(scene.flowPreset);
  ColorPreset cp = colorPresets.get(scene.colorPreset);
  
  println("Current Preset: " + currentPreset + 
          " | Particles: " + particles.size() + 
          " | Render Mode: " + (pp != null ? pp.renderMode : "default") +
          " | Movement Mode: " + (pp != null ? pp.movementMode : "default") +
          " | Flow Scale: " + (fp != null ? fp.noiseScale : flowField.noiseScale) +
          " | Color Scheme: " + (cp != null ? cp.scheme : colors.currentScheme));
}


class ScenePreset {
  String flowPreset;
  String particlePreset;
  String colorPreset;
  
  ScenePreset(String f, String p, String c) {
    flowPreset = f;
    particlePreset = p;
    colorPreset = c;
  }
}