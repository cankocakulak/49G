class Square {
  PVector position;
  PVector velocity;
  float size;
  color squareColor;
  
  // Constants for size changes
  final float SIZE_CHANGE_RATE = 5;
  final float MIN_SIZE = 50;
  final float MAX_SIZE = 200;
  
  Square(float x, float y, color c) {
    position = new PVector(x, y);
    float angle = random(-PI/2, 0);
    velocity = PVector.fromAngle(angle);
    velocity.mult(SPEED);
    size = 80;
    squareColor = c;
  }
  
  void update() {
    updatePosition();
    checkWallCollisions();
  }
  
  void updatePosition() {
    position.add(velocity);
  }
  
  void checkWallCollisions() {
    // Horizontal collisions - constrain position and bounce
    if (position.x < 0) {
      position.x = 0;
      velocity.x *= -1;
    } else if (position.x > width - size) {
      position.x = width - size;
      velocity.x *= -1;
    }
    
    // Vertical collisions - constrain position, bounce, and grow
    if (position.y < 0) {
      position.y = 0;
      velocity.y *= -1;
      grow();
    } else if (position.y > height - size) {
      position.y = height - size;
      velocity.y *= -1;
      grow();
    }
  }
  
  void grow() {
    // Limit growth rate and maximum size
    float growthRate = 2.0;  // Smaller growth increment
    float newSize = size + growthRate;
    size = constrain(newSize, MIN_SIZE, MAX_SIZE);
  }
  
  void shrink() {
    // Limit shrink rate and minimum size
    float shrinkRate = 2.0;  // Smaller shrink increment
    float newSize = size - shrinkRate;
    size = constrain(newSize, MIN_SIZE, MAX_SIZE);
  }
  
  void display() {
    // Draw the square fill
    noStroke();
    fill(squareColor);
    rectMode(CORNER);
    rect(position.x, position.y, size, size);
    
    // Draw red edges on top and bottom
    strokeWeight(3);
    stroke(255, 0, 0);
    // Top edge
    line(position.x, position.y, position.x + size, position.y);
    // Bottom edge
    line(position.x, position.y + size, position.x + size, position.y + size);
    
    // Draw size text in the center
    fill(0);  // Black text
    textAlign(CENTER, CENTER);
    textSize(size/4);  // Scale text size relative to square size
    text(nf(size, 0, 0), position.x + size/2, position.y + size/2);
  }
}