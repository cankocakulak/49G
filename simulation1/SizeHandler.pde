class SizeHandler {
  float growthRate = 10.0;    
  int cooldownFrames = 30;   
  int lastChangeFrame = 0;   
  
  void handleVerticalCollision(Square s1, Square s2) {
    if (!isColliding(s1, s2)) return;
    if (frameCount - lastChangeFrame < cooldownFrames) return;
    
    // Calculate overlap percentages
    float horizontalOverlap = calculateHorizontalOverlap(s1, s2);
    float minSize = min(s1.size, s2.size);
    
    // Check if squares are vertically aligned enough (at least 50% horizontal overlap)
    if (horizontalOverlap > minSize * 0.5) {
      // Check if one square is clearly above the other
      boolean isVerticalCollision = 
        (s1.position.y + s1.size > s2.position.y && s1.position.y < s2.position.y) ||
        (s2.position.y + s2.size > s1.position.y && s2.position.y < s1.position.y);
        
      if (isVerticalCollision && canChangeSize(s1, s2)) {
        if (s1.position.y < s2.position.y) {
          s1.grow(growthRate);
          s2.shrink(growthRate);
        } else {
          s2.grow(growthRate);
          s1.shrink(growthRate);
        }
        lastChangeFrame = frameCount;
      }
    }
  }
  
  private float calculateHorizontalOverlap(Square s1, Square s2) {
    float left = max(s1.position.x, s2.position.x);
    float right = min(s1.position.x + s1.size, s2.position.x + s2.size);
    return max(0, right - left);
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