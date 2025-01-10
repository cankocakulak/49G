// Main simulation file
ArrayList<Square> squares;
float SPEED = 15;

void setup() {
  size(800, 800);
  squares = new ArrayList<Square>();
  
  // Create squares with different positions and colors
  squares.add(new Square(width/4, height/3, 
              color(255, 100, 100))); // Red-ish square
              
  squares.add(new Square(3*width/4, 2*height/3, 
              color(100, 100, 255))); // Blue-ish square
  
  background(0);
}

void draw() {
  background(0);
  
  // Update and display all squares
  for (Square square : squares) {
    square.update(squares);  // Pass the list of squares for collision detection
    square.display();
  }
}