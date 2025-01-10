class SizeHandler {
  float growthRate = 5.0;    // Reduced from 10.0 for smoother changes
  int cooldownFrames = 15;   // Reduced cooldown for more frequent changes
  int lastChangeFrame = 0;   
  
  void handleCollision(Square s1, Square s2) {
    if (!isColliding(s1, s2)) return;
    if (frameCount - lastChangeFrame < cooldownFrames) return;
    
    // Determine which square has higher position (regardless of collision type)
    if (canChangeSize(s1, s2)) {
      // The square with higher Y position (lower on screen) shrinks
      if (s1.position.y + s1.size/2 > s2.position.y + s2.size/2) {
        s2.grow(growthRate);
        s1.shrink(growthRate);
      } else {
        s1.grow(growthRate);
        s2.shrink(growthRate);
      }
      lastChangeFrame = frameCount;
    }
  }
  
  private boolean isColliding(Square s1, Square s2) {
    return !(s1.position.x + s1.size < s2.position.x || 
             s1.position.x > s2.position.x + s2.size ||
             s1.position.y + s1.size < s2.position.y ||
             s1.position.y > s2.position.y + s2.size);
  }
  
  private boolean canChangeSize(Square s1, Square s2) {
    float maxSpeed = 30.0;
    if (s1.velocity.mag() > maxSpeed || s2.velocity.mag() > maxSpeed) {
      return false;
    }
    
    boolean s1CanGrow = s1.size < s1.MAX_SIZE;
    boolean s2CanGrow = s2.size < s2.MAX_SIZE;
    boolean s1CanShrink = s1.size > s1.MIN_SIZE;
    boolean s2CanShrink = s2.size > s2.MIN_SIZE;
    
    return (s1CanGrow && s2CanShrink) || (s2CanGrow && s1CanShrink);
  }
}