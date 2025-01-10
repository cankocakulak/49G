class SquareCollisionHandler {
  boolean enableSeparation = true;    
  boolean enableVelocitySwap = true;  
  boolean enableColorMix = true;      
  boolean enableVerticalSize = true;  
  
  void handleCollision(Square s1, Square s2) {
    if (!isColliding(s1, s2)) return;
    
    if (enableSeparation) {
      handleSeparation(s1, s2);
    }
    
    if (enableVelocitySwap) {
      handleRealisticCollision(s1, s2);
    }
    
    if (enableColorMix) {
      handleColorMix(s1, s2);
    }
    
    if (enableVerticalSize) {
      handleVerticalSize(s1, s2);
    }
  }
  
  private void handleSeparation(Square s1, Square s2) {
    float dx = (s1.position.x + s1.size/2) - (s2.position.x + s2.size/2);
    float dy = (s1.position.y + s1.size/2) - (s2.position.y + s2.size/2);
    
    float minDist = (s1.size + s2.size) / 2;
    float dist = sqrt(dx*dx + dy*dy);
    
    if (dist < minDist && dist > 0) {
      float moveX = dx/dist * (minDist - dist) * 0.5;
      float moveY = dy/dist * (minDist - dist) * 0.5;
      
      s1.position.x += moveX;
      s1.position.y += moveY;
      s2.position.x -= moveX;
      s2.position.y -= moveY;
    }
  }
  
  private void handleRealisticCollision(Square s1, Square s2) {
    // Store original speeds
    float speed1 = s1.velocity.mag();
    float speed2 = s2.velocity.mag();
    
    // Calculate collision normal
    PVector normal = new PVector(
      s2.position.x + s2.size/2 - (s1.position.x + s1.size/2),
      s2.position.y + s2.size/2 - (s1.position.y + s1.size/2)
    );
    normal.normalize();
    
    // Calculate reflection angles using dot product
    PVector v1 = s1.velocity.copy();
    PVector v2 = s2.velocity.copy();
    
    // Reflect velocities
    float dot1 = 2 * (v1.x * normal.x + v1.y * normal.y);
    float dot2 = 2 * (v2.x * (-normal.x) + v2.y * (-normal.y));
    
    PVector v1Reflected = new PVector(
      v1.x - dot1 * normal.x,
      v1.y - dot1 * normal.y
    );
    
    PVector v2Reflected = new PVector(
      v2.x - dot2 * (-normal.x),
      v2.y - dot2 * (-normal.y)
    );
    
    // Set new velocities while maintaining original speeds
    s1.velocity = v1Reflected.normalize().mult(speed1);
    s2.velocity = v2Reflected.normalize().mult(speed2);
  }
  
  private void handleColorMix(Square s1, Square s2) {
    color newColor1 = lerpColor(s1.squareColor, s2.squareColor, 0.3);
    color newColor2 = lerpColor(s2.squareColor, s1.squareColor, 0.3);
    s1.squareColor = newColor1;
    s2.squareColor = newColor2;
  }
  
  private void handleVerticalSize(Square s1, Square s2) {
    if (frameCount % 10 == 0) {
      // Calculate horizontal overlap
      float s1Right = s1.position.x + s1.size;
      float s2Right = s2.position.x + s2.size;
      float s1Left = s1.position.x;
      float s2Left = s2.position.x;
      
      // Check if there's significant horizontal overlap
      if (!(s1Right < s2Left || s1Left > s2Right)) {
        float overlap = min(s1Right, s2Right) - max(s1Left, s2Left);
        float minSize = min(s1.size, s2.size);
        
        if (overlap > minSize * 0.5) {
          // Ensure squares are vertically aligned (one clearly above the other)
          float verticalGap = abs(s1.position.y - s2.position.y);
          if (verticalGap < s1.size || verticalGap < s2.size) {
            if (s1.position.y < s2.position.y) {
              s1.grow();
              s2.shrink();
            } else {
              s2.grow();
              s1.shrink();
            }
          }
        }
      }
    }
  }
  
  boolean isColliding(Square s1, Square s2) {
    return !(s1.position.x + s1.size < s2.position.x || 
             s1.position.x > s2.position.x + s2.size ||
             s1.position.y + s1.size < s2.position.y ||
             s1.position.y > s2.position.y + s2.size);
  }
  
  void setEffects(boolean velocity, boolean colorMix, boolean size) {
    enableVelocitySwap = velocity;
    enableColorMix = colorMix;
    enableVerticalSize = size;
  }
} 