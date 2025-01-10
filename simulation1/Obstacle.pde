class Obstacle {
  PVector position;
  float size;
  color obstacleColor;
  
  Obstacle(float x, float y, float s) {
    position = new PVector(x, y);
    size = s;
    obstacleColor = color(150, 150, 150);  // Gray color
  }
  
  void display() {
    noStroke();
    fill(obstacleColor);
    rectMode(CORNER);
    rect(position.x, position.y, size, size);
    
    // Add red edges like squares
    strokeWeight(3);
    stroke(255, 0, 0);
    line(position.x, position.y, position.x + size, position.y);
    line(position.x, position.y + size, position.x + size, position.y + size);
  }
}