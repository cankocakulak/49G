class SquareCollisionHandler {
  
  void handleCollision(Square s1, Square s2) {
    if (!isColliding(s1, s2)) return;
    
    // First separate the squares to prevent sticking
    separateSquares(s1, s2);
    
    // Handle collision physics
    handleCollisionPhysics(s1, s2);
  }
  
  private void separateSquares(Square s1, Square s2) {
    float dx = s2.position.x - s1.position.x;
    float dy = s2.position.y - s1.position.y;
    
    float dist = sqrt(dx*dx + dy*dy);
    if (dist == 0) return;
    
    dx /= dist;
    dy /= dist;
    
    float separation = 1.0;
    s1.position.x -= dx * separation;
    s1.position.y -= dy * separation;
    s2.position.x += dx * separation;
    s2.position.y += dy * separation;
  }
  
  private void handleCollisionPhysics(Square s1, Square s2) {
    // Determine if collision is more horizontal or vertical
    float dx = abs((s1.position.x + s1.size/2) - (s2.position.x + s2.size/2));
    float dy = abs((s1.position.y + s1.size/2) - (s2.position.y + s2.size/2));
    
    if (dx > dy) {
      // Horizontal collision - swap x velocities
      float tempVelX = s1.velocity.x;
      s1.velocity.x = s2.velocity.x;
      s2.velocity.x = tempVelX;
    } else {
      // Vertical collision - swap y velocities
      float tempVelY = s1.velocity.y;
      s1.velocity.y = s2.velocity.y;
      s2.velocity.y = tempVelY;
    }
  }
  
  boolean isColliding(Square s1, Square s2) {
    return !(s1.position.x + s1.size < s2.position.x || 
             s1.position.x > s2.position.x + s2.size ||
             s1.position.y + s1.size < s2.position.y ||
             s1.position.y > s2.position.y + s2.size);
  }
  
  void handleObstacleCollision(Square square, Obstacle obstacle) {
    // Check collision with obstacle
    if (isCollidingWithObstacle(square, obstacle)) {
      // Calculate collision sides
      float dx = (square.position.x + square.size/2) - (obstacle.position.x + obstacle.size/2);
      float dy = (square.position.y + square.size/2) - (obstacle.position.y + obstacle.size/2);
      
      // Determine which side of the obstacle was hit
      if (abs(dx) > abs(dy)) {
        // Horizontal collision
        square.velocity.x *= -1;
        if (dx > 0) {
          square.position.x = obstacle.position.x + obstacle.size;
        } else {
          square.position.x = obstacle.position.x - square.size;
        }
      } else {
        // Vertical collision
        square.velocity.y *= -1;
        if (dy > 0) {
          square.position.y = obstacle.position.y + obstacle.size;
        } else {
          square.position.y = obstacle.position.y - square.size;
        }
      }
    }
  }
  
  private boolean isCollidingWithObstacle(Square square, Obstacle obstacle) {
    return !(square.position.x + square.size < obstacle.position.x || 
             square.position.x > obstacle.position.x + obstacle.size ||
             square.position.y + square.size < obstacle.position.y ||
             square.position.y > obstacle.position.y + obstacle.size);
  }
} 