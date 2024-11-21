// Colors class: Manages color palettes and provides color values based on position or noise.
// Allows customization of particle colors.
import java.util.Arrays;  // Add this import at the top


class Colors {
  HashMap<String, int[]> colorSchemes;
  String currentScheme;
  float colorNoiseScale = 0.1;  // Controls how quickly colors change spatially
  float colorBlendFactor = 0.5;

  // Add default values
  final String defaultScheme = "forest_deep";  // Default color scheme
  final float defaultNoiseScale = 0.01;        // Default noise scale

  void resetToDefault() {
    currentScheme = defaultScheme;
    colorNoiseScale = defaultNoiseScale;
    // Reset any other color-related variables
  }
  Colors() {
    colorSchemes = new HashMap<String, int[]>();
    
    colorSchemes.put("ocean_calm", new int[] {
      color(0, 105, 148, 200),
      color(0, 154, 199, 200),
      color(77, 196, 255, 200),
      color(130, 222, 255, 200)
    });
    
    colorSchemes.put("sunset_dynamic", new int[] {
      color(255, 87, 51, 200),
      color(255, 189, 51, 200),
      color(255, 139, 51, 200),
      color(255, 87, 51, 200)
    });
    
    colorSchemes.put("forest_deep", new int[] {
      color(34, 139, 34, 200),
      color(0, 100, 0, 200),
      color(85, 107, 47, 200),
      color(154, 205, 50, 200)
    });
    
    colorSchemes.put("cosmic_dark", new int[] {
      color(40, 46, 52, 200),    // Dark slate
      color(70, 80, 87, 200),    // Mountain shadow
      color(120, 130, 135, 200), // Misty gray
      color(150, 155, 160, 200)  // Light peak
    });

      colorSchemes.put("dark_converge", new int[] {
          color(20, 20, 30, 200),    // Very dark blue
          color(40, 40, 60, 200),    // Dark purple-blue
          color(60, 20, 80, 200),    // Dark purple
          color(80, 20, 100, 200)    // Deep purple
      });
    
    currentScheme = "forest_deep";  // Updated default
    
  }

  int getColor(float x, float y) {
    int[] currentPalette = colorSchemes.get(currentScheme);
    
    // Use Perlin noise for smooth color transitions
    float n = noise(x * colorNoiseScale, y * colorNoiseScale, frameCount * 0.001);
    
    // Get two adjacent colors for blending
    int index1 = floor(n * currentPalette.length);
    int index2 = (index1 + 1) % currentPalette.length;
    
    // Blend between the two colors
    float blend = (n * currentPalette.length) % 1.0;
    return lerpColor(
      currentPalette[index1 % currentPalette.length],
      currentPalette[index2 % currentPalette.length],
      blend
    );
  }
  

  void setScheme(String schemeName) {
    if (colorSchemes.containsKey(schemeName)) {
      currentScheme = schemeName;
    }
  }
  
  void nextScheme() {
    String[] schemes = colorSchemes.keySet().toArray(new String[0]);
    int currentIndex = Arrays.asList(schemes).indexOf(currentScheme);
    currentScheme = schemes[(currentIndex + 1) % schemes.length];
  }
  
  void setColorNoiseScale(float scale) {
    colorNoiseScale = scale;
  }
}