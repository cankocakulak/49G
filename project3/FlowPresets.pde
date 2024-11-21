static class FlowPreset {
  float noiseScale;
  float zoff;
  
  FlowPreset(float ns, float z) {
    noiseScale = ns;
    zoff = z;
  }
}

static HashMap<String, FlowPreset> flowPresets = new HashMap<String, FlowPreset>() {{
    // Basic flows
    put("calm", new FlowPreset(0.05, 0.001));       // Gentle, smooth movement
    put("storm", new FlowPreset(0.2, 0.005));       // Chaotic, fast movement
    put("cosmic", new FlowPreset(0.08, 0.002));     // Medium, swirling movement
    
    // Special effect flows
    put("gentle", new FlowPreset(0.04, 0.001));     // For fountain/rain
    put("swirly", new FlowPreset(0.1, 0.003));      // For spiral effects
    put("explosive", new FlowPreset(0.15, 0.004));   // For firework effects
    put("downward", new FlowPreset(0.07, 0.002));   // For curtain effects
    put("upward", new FlowPreset(0.06, 0.002));     // For upward effects
}};