// Main simulation file
ArrayList<Square> squares;
SquareCollisionHandler collisionHandler;
float SPEED = 10;

void setup() {
  size(800, 800);
  squares = new ArrayList<Square>();
  collisionHandler = new SquareCollisionHandler();
  
  // Configure which effects you want
  collisionHandler.setEffects(
    true,   // velocity swap
    false,   // color mixing
    true    // vertical size changes
  );
  
  squares.add(new Square(width/4, height/3, 
              color(255, 100, 100)));
              
  squares.add(new Square(3*width/4, 2*height/3, 
              color(100, 100, 255)));
  
  background(0);
}

void draw() {
  background(0);
  
  // Update positions
  for (Square square : squares) {
    square.update();
  }
  
  // Check collisions
  for (int i = 0; i < squares.size(); i++) {
    for (int j = i + 1; j < squares.size(); j++) {
      Square s1 = squares.get(i);
      Square s2 = squares.get(j);
      collisionHandler.handleCollision(s1, s2);
    }
  }
  
  // Display squares
  for (Square square : squares) {
    square.display();
  }
}