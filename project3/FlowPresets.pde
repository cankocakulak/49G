static class FlowPreset {
  float noiseScale;
  float zoff;
  
  FlowPreset(float ns, float z) {
    noiseScale = ns;
    zoff = z;
  }
}

static HashMap<String, FlowPreset> flowPresets = new HashMap<String, FlowPreset>() {{
  put("calm", new FlowPreset(0.05, 0.001));
  put("storm", new FlowPreset(0.2, 0.005));
  put("cosmic", new FlowPreset(0.08, 0.002));
}};