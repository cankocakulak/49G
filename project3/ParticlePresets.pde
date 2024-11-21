static class ParticlePreset {
  float maxSpeed;
  float decay;
  float strokeWeight;
  int count;
  String spawnPattern;    // "full", "center", "top", etc.
  String renderMode;      // "point", "line", "circle"
  String movementMode;    // "flow", "radial", "downward", etc.
  
  ParticlePreset(float ms, float d, float sw, int c, String sp, String rm, String mm) {
    maxSpeed = ms;
    decay = d;
    strokeWeight = sw;
    count = c;
    spawnPattern = sp;
    renderMode = rm;
    movementMode = mm;
  }
}

static HashMap<String, ParticlePreset> particlePresets = new HashMap<String, ParticlePreset>() {{
  // Flow-based presets
  put("sparse_flow", new ParticlePreset(
    1.5, 0.98, 1.0, 8000, "full", "point", "flow"
  ));
  
  put("dense_flow", new ParticlePreset(
    4.0, 0.95, 2.0, 12000, "full", "point", "flow"
  ));
  
  put("fine_flow", new ParticlePreset(
    2.0, 0.99, 0.7, 15000, "full", "point", "flow"
  ));
  
  // Special effect presets
  put("rain_effect", new ParticlePreset(
    4.0, 0.99, 1.5, 1000, "top", "line", "rain"
  ));
  
  put("fountain_effect", new ParticlePreset(
    5.0,      // maxSpeed
    0.995,    // decay (longer lasting)
    3.0,      // strokeWeight
    2000,     // count (fewer particles)
    "bottom", // spawnPattern
    "circle", // renderMode
    "fountain" // movementMode
  ));
  
  put("spiral_effect", new ParticlePreset(
    2.0, 0.99, 1.0, 2000, "center", "point", "spiral"
  ));
  
  put("firework_effect", new ParticlePreset(
    3.0, 0.96, 2.0, 1500, "center", "point", "firework"
  ));
  
  put("curtain_effect", new ParticlePreset(
    2.0, 0.99, 1.5, 3000, "top", "line", "curtain"
  ));
  
  put("vortex_effect", new ParticlePreset(
    2.2, 0.97, 1.2, 6000, "full", "line", "vortex"
  ));
}};