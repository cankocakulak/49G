// Main simulation file
ArrayList<Square> squares;
SquareCollisionHandler collisionHandler;
SizeHandler sizeHandler;
Obstacle centerObstacle;
PImage logo;
boolean hasLogo = false;
float SPEED = 10.0;

void setup() {
  size(800, 800);
  squares = new ArrayList<Square>();
  collisionHandler = new SquareCollisionHandler();
  sizeHandler = new SizeHandler();
  
  // Try to load logo
  try {
    logo = loadImage("logo.png");
    if (logo != null) {
      logo.resize(width/3, 0);
      hasLogo = true;
    }
  } catch (Exception e) {
    println("Logo not found, continuing without it");
    hasLogo = false;
  }
  
  // Create center obstacle
  centerObstacle = new Obstacle(width/2 - 50, height/2 - 50, 100);
  centerObstacle.obstacleColor = #553555;  // Purple
  
  // Create squares with titles
  squares.add(new Square(width/4, height/3, 
              #D8783E,  // Orange
              "Square 1"));
              
  squares.add(new Square(3*width/4, 2*height/3, 
              #024A43,  // Green
              "Square 2"));
  
  background(255);
}

void draw() {
  background(255);  // White background
  
  // Draw logo if available - now positioned lower
  if (hasLogo) {
    imageMode(CENTER);
    tint(255, 128);  // Semi-transparent
    image(logo, width/5, height * 0.85);  // Positioned at 85% of screen height
  }
  
  // Update positions
  for (Square square : squares) {
    square.update();
    collisionHandler.handleObstacleCollision(square, centerObstacle);
  }
  
  // Check collisions between squares
  for (int i = 0; i < squares.size(); i++) {
    for (int j = i + 1; j < squares.size(); j++) {
      Square s1 = squares.get(i);
      Square s2 = squares.get(j);
      collisionHandler.handleCollision(s1, s2);
      sizeHandler.handleCollision(s1, s2);
    }
  }
  
  // Display everything
  centerObstacle.display();
  for (Square square : squares) {
    square.display();
  }
}