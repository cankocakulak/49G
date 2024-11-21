// Main program: Initializes particles, flow field, and color palette.
ArrayList<Particle> particles;
FlowField flowField;
Colors colors;
String currentPreset = "default";
import java.util.Iterator;
ArrayList<ParticleState> undoStates = new ArrayList<ParticleState>();
int maxUndoStates = 10;  // Maximum number of states to remember


int scl = 20; // Scale of the flow field grid


class ParticleState {
    ArrayList<Particle> particles;
    String preset;
    PImage frameSnapshot;
    
    ParticleState(ArrayList<Particle> currentParticles, String currentPreset) {
        particles = new ArrayList<Particle>();
        for (Particle p : currentParticles) {
            particles.add(p.copy());
        }
        preset = currentPreset;
        
        // Ensure we capture the full frame
        frameSnapshot = createImage(width, height, RGB);
        frameSnapshot.copy(get(), 0, 0, width, height, 0, 0, width, height);
    }
}

//Save current state
void saveState() {
    if (undoStates.size() > 0) {
        // Only save if the current state is different from the last saved state
        ParticleState lastState = undoStates.get(undoStates.size() - 1);
        if (particles.size() == lastState.particles.size()) {
            return;  // Skip saving if particle count hasn't changed
        }
    }
    
    undoStates.add(new ParticleState(particles, currentPreset));
    if (undoStates.size() > maxUndoStates) {
        undoStates.remove(0);
    }
    println("State saved! States available to undo: " + undoStates.size());
}

void setPreset(String preset) {
  ScenePreset scene = scenePresets.get(preset);
  if (scene == null) {
    println("ERROR: Scene preset not found: " + preset);
    return;
  }
  
  currentPreset = preset;
  
  // Get all presets
  ParticlePreset pp = particlePresets.get(scene.particlePreset);
  FlowPreset fp = flowPresets.get(scene.flowPreset);
  ColorPreset cp = colorPresets.get(scene.colorPreset);
  
  if (pp == null) println("ERROR: Particle preset not found: " + scene.particlePreset);
  if (fp == null) println("ERROR: Flow preset not found: " + scene.flowPreset);
  if (cp == null) println("ERROR: Color preset not found: " + scene.colorPreset);
  
  if (pp == null || fp == null || cp == null) return;
  
  // Reset everything first
  colors.resetToDefault();
  
  // Then apply new settings
  colors.setScheme(cp.scheme);
  colors.setColorNoiseScale(cp.noiseScale);
  flowField.setNoiseScale(fp.noiseScale);
  flowField.setZoffIncrement(fp.zoff);
  
  // Clear existing particles
  particles.clear();
  
  // Debug info
  println("Set preset: " + preset);
  println("Color scheme set to: " + cp.scheme);
  println("Flow preset: " + scene.flowPreset);
  println("Particle preset: " + scene.particlePreset);
}

//Setup of background
void setup() {
  size(800, 800);
  particles = new ArrayList<Particle>();
  flowField = new FlowField(width, height, scl);
  colors = new Colors();
  colors.resetToDefault();  // Ensure we start with default colors
  background(0);
}


void draw() {
  flowField.update();
  
  // Temporary lists for modifications
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
        
        ScenePreset scene = scenePresets.get(currentPreset);
        if (scene != null) {
            ParticlePreset pp = particlePresets.get(scene.particlePreset);
            ColorPreset cp = colorPresets.get(scene.colorPreset);
            
            if (pp != null && cp != null) {
                // Maintain current color scheme
                colors.setScheme(cp.scheme);
                colors.setColorNoiseScale(cp.noiseScale);
                
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
    }
    
    p.show();
  }
  
  // After iteration: perform removals and additions
  particles.removeAll(particlesToRemove);
  particles.addAll(particlesToAdd);
}


// Keyboard control
void keyPressed() {

  if (key == 'z') {
    if (undoStates.size() > 0) {
        // Get the last state
        ParticleState lastState = undoStates.remove(undoStates.size() - 1);
        
        // Clear the screen first
        background(255);  // Add this line
        
        // Then restore visual state
        image(lastState.frameSnapshot, 0, 0);
        
        // Rest of the restoration code...
    }
  }

  else if (key >= '0' && key <= '9') {
    saveState();  // Save before changing preset

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
      case '0': setPreset("triangle_converge"); break;

    }
  }

  else if (key == 'c') {
   setPreset("triangle_top");    
  }
  else if (key == 'x') {
    setPreset("triangle_left");
  }
  else if (key == 'v') {
    setPreset("triangle_right");
  }


  else if (key == 'w') {  // Add particles
      saveState();
      ScenePreset scene = scenePresets.get(currentPreset);
      if (scene != null) {
          ParticlePreset pp = particlePresets.get(scene.particlePreset);
          ColorPreset cp = colorPresets.get(scene.colorPreset);  // Get color preset
          if (pp != null && cp != null) {  // Check both presets
              // Set color scheme before creating particles
              colors.setScheme(cp.scheme);
              colors.setColorNoiseScale(cp.noiseScale);
              
              int batchSize = 500;
              for (int i = 0; i < batchSize; i++) {
                  PVector pos = getSpawnPosition(pp.spawnPattern);
                  Particle p = new Particle(pos.x, pos.y, colors, pp.renderMode, pp.movementMode);
                  p.setProperties(pp.maxSpeed, pp.decay, pp.strokeWeight);
                  
                  if (pp.movementMode.equals("fountain")) {
                      p.vel = new PVector(random(-2, 2), -random(8, 12));
                  }
                  
                  particles.add(p);
              }
              println("Added " + batchSize + " particles with color scheme: " + cp.scheme);
          }
      }
  }

  else if (key == 's') {  // Remove particles
    saveState();  // Save before removing

    int removeCount = min(500, particles.size());  // Remove 500 at a time
    for (int i = 0; i < removeCount; i++) {
      particles.remove(particles.size()-1);
    }
    println("Removed " + removeCount + " particles. Total: " + particles.size());
  }
  
  else if (key == 'r') {  // Reset to empty
    saveState();  // Add this line to save before reset

    particles.clear();
    background(0);
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
    "grey_scale"    // color preset
  ));
  
  put("storm_flow", new ScenePreset(
    "storm",
    "dense_flow",
    "cool_grey"
  ));
  
  put("cosmic_flow", new ScenePreset(
    "cosmic",
    "fine_flow",
    "warm_grey"
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

  put("triangle_converge", new ScenePreset(
    "gentle",              // gentle flow
    "triangle_converge",   // our new particle preset
    "dark_converge"       // warm colors look nice
  ));

  put("triangle_top", new ScenePreset(
    "gentle",              // gentle flow
    "triangle_top",   // our new particle preset
    "dark_converge"       // warm colors look nice
  ));

  put("triangle_left", new ScenePreset(
    "gentle",              // gentle flow
    "triangle_left",   // our new particle preset
    "dark_converge"       // warm colors look nice
  ));

  put("triangle_right", new ScenePreset(
    "gentle",              // gentle flow
    "triangle_right",   // our new particle preset
    "dark_converge"       // warm colors look nice
  ));

}};

void resetSketch() {
    background(0);
    particles.clear();
    
    ScenePreset scene = scenePresets.get(currentPreset);
    if (scene == null) return;
    
    ParticlePreset pp = particlePresets.get(scene.particlePreset);
    ColorPreset cp = colorPresets.get(scene.colorPreset);
    
    if (pp != null && cp != null) {
        // Set color scheme before creating particles
        colors.setScheme(cp.scheme);
        colors.setColorNoiseScale(cp.noiseScale);
        
        for (int i = 0; i < pp.count; i++) {
            PVector pos = getSpawnPosition(pp.spawnPattern);
            Particle p = new Particle(pos.x, pos.y, colors, pp.renderMode, pp.movementMode);
            p.setProperties(pp.maxSpeed, pp.decay, pp.strokeWeight);
            particles.add(p);
        }
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