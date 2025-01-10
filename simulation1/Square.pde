class Square {
  PVector position;
  PVector velocity;
  float size;
  color squareColor;
  
  // Constants for size changes
  final float SIZE_CHANGE_RATE = 5;
  final float MIN_SIZE = 20;
  final float MAX_SIZE = 100;
  
  Square(float x, float y, color c) {
    position = new PVector(x, y);
    
    // Random initial angle between -PI/2 and 0 (upward-right quadrant)
    float angle = random(-PI/2, 0);
    velocity = PVector.fromAngle(angle);
    velocity.mult(SPEED);
    
    size = 50;
    squareColor = c;
  }
  
  void update(ArrayList<Square> squares) {
    updatePosition();
    checkWallCollisions();
    checkSquareCollisions(squares);
  }
  
  void updatePosition() {
    position.add(velocity);
  }
  
  void checkWallCollisions() {
    // Horizontal collisions
    if (position.x < 0 || position.x > width - size) {
      velocity.x *= -1;
    }
    
    // Vertical collisions with size changes
    if (position.y < 0) {
      velocity.y *= -1;
      grow();
    }
    if (position.y > height - size) {
      velocity.y *= -1;
      shrink();
    }
  }
  
  void checkSquareCollisions(ArrayList<Square> squares) {
    for (Square other : squares) {
      if (other != this && isColliding(other)) {
        handleCollision(other);
      }
    }
  }
  
  boolean isColliding(Square other) {
    return !(position.x + size < other.position.x || 
             position.x > other.position.x + other.size ||
             position.y + size < other.position.y ||
             position.y > other.position.y + other.size);
  }
  
  void handleCollision(Square other) {
    // Swap velocities for realistic collision
    PVector tempVel = velocity.copy();
    velocity = other.velocity.copy();
    other.velocity = tempVel;
    
    // Mix colors on collision
    squareColor = lerpColor(squareColor, other.squareColor, 0.3);
  }
  
  void grow() {
    size = constrain(size + SIZE_CHANGE_RATE, MIN_SIZE, MAX_SIZE);
  }
  
  void shrink() {
    size = constrain(size - SIZE_CHANGE_RATE, MIN_SIZE, MAX_SIZE);
  }
  
  void display() {
    noStroke();
    fill(squareColor);
    rectMode(CORNER);
    rect(position.x, position.y, size, size);
  }
}