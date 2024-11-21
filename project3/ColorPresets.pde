static class ColorPreset {
  String scheme;
  float noiseScale;
  
  ColorPreset(String s, float ns) {
    scheme = s;
    noiseScale = ns;
  }
}

static HashMap<String, ColorPreset> colorPresets = new HashMap<String, ColorPreset>() {{
  put("ocean_calm", new ColorPreset("ocean", 0.005));
  put("sunset_dynamic", new ColorPreset("sunset", 0.02));
  put("forest_deep", new ColorPreset("forest", 0.015));
}};