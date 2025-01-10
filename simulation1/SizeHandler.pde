class SizeHandler {
  float growthRate = 1.0;    
  int cooldownFrames = 30;   
  int lastChangeFrame = 0;   
  
  void handleVerticalCollision(Square s1, Square s2) {
    // First check if squares are actually colliding
    if (!isColliding(s1, s2)) {
      println("Not colliding");
      return;
    }
    
    // Check cooldown period
    if (frameCount - lastChangeFrame < cooldownFrames) {
      println("Cooldown active");
      return;
    }
    
    // Determine if it's a vertical collision by checking relative positions
    float dx = abs((s1.position.x + s1.size/2) - (s2.position.x + s2.size/2));
    float dy = abs((s1.position.y + s1.size/2) - (s2.position.y + s2.size/2));
    
    println("dx: " + dx + ", dy: " + dy);  // Debug distances
    
    // If horizontal distance is less than vertical distance and squares overlap significantly
    if (dx < s1.size/2 + s2.size/2) {  // Check for significant horizontal overlap
      println("Horizontal overlap detected");
      
      if (canChangeSize(s1, s2)) {
        // Determine which square is on top
        if (s1.position.y < s2.position.y) {
          println("S1 on top - Growing s1: " + s1.size + ", Shrinking s2: " + s2.size);
          s1.grow(growthRate);
          s2.shrink(growthRate);
        } else {
          println("S2 on top - Growing s2: " + s2.size + ", Shrinking s1: " + s1.size);
          s2.grow(growthRate);
          s1.shrink(growthRate);
        }
        lastChangeFrame = frameCount;
      } else {
        println("Can't change size - speed or size limits reached");
      }
    } else {
      println("Not enough horizontal overlap");
    }
  }
  
  private boolean isColliding(Square s1, Square s2) {
    boolean colliding = !(s1.position.x + s1.size < s2.position.x || 
                         s1.position.x > s2.position.x + s2.size ||
                         s1.position.y + s1.size < s2.position.y ||
                         s1.position.y > s2.position.y + s2.size);
    
    if (colliding) {
      println("Collision detected!");
    }
    return colliding;
  }
  
  private boolean canChangeSize(Square s1, Square s2) {
    float maxSpeed = 7.0;
    if (s1.velocity.mag() > maxSpeed || s2.velocity.mag() > maxSpeed) {
      println("Speed too high: " + s1.velocity.mag() + ", " + s2.velocity.mag());
      return false;
    }
    
    // Check if either square is at its size limit
    boolean s1CanGrow = s1.size < s1.MAX_SIZE;
    boolean s2CanGrow = s2.size < s2.MAX_SIZE;
    boolean s1CanShrink = s1.size > s1.MIN_SIZE;
    boolean s2CanShrink = s2.size > s2.MIN_SIZE;
    
    println("Size limits - S1: " + s1.size + ", S2: " + s2.size);
    
    return (s1CanGrow && s2CanShrink) || (s2CanGrow && s1CanShrink);
  }
}