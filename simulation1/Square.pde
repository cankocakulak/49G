class Square {
  PVector position;
  PVector velocity;
  float size;
  color squareColor;
  String title;
  
  final float MIN_SIZE = 100;
  final float MAX_SIZE = 200;
  final float DEFAULT_GROWTH_RATE = 2.0;
  
  Square(float x, float y, color c, String t) {
    position = new PVector(x, y);
    float angle = random(-PI/2, 0);
    velocity = PVector.fromAngle(angle);
    velocity.mult(SPEED);
    size = 150;
    squareColor = c;
    title = t;
  }
  
  void grow(float rate) {
    float newSize = size + rate;
    size = constrain(newSize, MIN_SIZE, MAX_SIZE);
  }
  
  void shrink(float rate) {
    float newSize = size - rate;
    size = constrain(newSize, MIN_SIZE, MAX_SIZE);
  }
  
  // Default methods for backward compatibility
  void grow() {
    grow(DEFAULT_GROWTH_RATE);
  }
  
  void shrink() {
    shrink(DEFAULT_GROWTH_RATE);
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
     // grow(DEFAULT_GROWTH_RATE);
    } else if (position.y > height - size) {
      position.y = height - size;
      velocity.y *= -1;
      //grow(DEFAULT_GROWTH_RATE);
    }
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
    fill(255);  // White text
    textAlign(CENTER, CENTER);
    textSize(size/3);
    text(nf(size, 0, 0), position.x + size/2, position.y + size/2);
    
    // Draw title above the square
    textSize(24);
    fill(0);  // Black text for title
    text(title, position.x + size/2, position.y - 20);
  }
}