static class ColorPreset {
  String scheme;
  float noiseScale;
  
  ColorPreset(String s, float ns) {
    scheme = s;
    noiseScale = ns;
  }
}

static HashMap<String, ColorPreset> colorPresets = new HashMap<String, ColorPreset>() {{
  // Names now match exactly with Colors class schemes
  put("ocean_calm", new ColorPreset("ocean_calm", 0.005));
  put("sunset_dynamic", new ColorPreset("sunset_dynamic", 0.02));
  put("forest_deep", new ColorPreset("forest_deep", 0.015));
  put("cosmic_dark", new ColorPreset("cosmic_dark", 0.01));
  put("dark_converge", new ColorPreset("dark_converge", 0.01));  // Slow color variation
}};