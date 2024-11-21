// Particle class: Represents individual particles that follow the flow field.
// Includes movement logic and rendering (with colors from the Colors class).


class Particle {
  PVector pos, vel, acc;
  float maxSpeed = 2;        // Maximum particle speed
  Colors colors;
  float lifespan = 255;      // Starting opacity
  float decay = 0.95;        // How quickly particles fade (closer to 1 = longer lasting)
  float strokeWeight = random(1, 3);  // Thickness of particles
  String renderMode = "point";
  String movementMode = "flow";

    Particle(float x, float y, Colors c, String rm, String mm) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    colors = c;
    renderMode = rm;
    movementMode = mm;
  }

  void follow(FlowField flow) {
    int x = floor(pos.x / flow.scl);
    int y = floor(pos.y / flow.scl);
    int index = constrain(x + y * flow.cols, 0, flow.field.length - 1);
    PVector force = flow.field[index];
    applyForce(force);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

   
 void update() {
  if (movementMode.equals("fountain")) {
    // Apply gravity
    vel.y += 0.2;
    pos.add(vel);
    
    // Reset particle if it goes below screen
    if (pos.y > height) {
      // Reset to fountain source
      pos.x = width/2 + random(-20, 20);
      pos.y = height;
      // New upward velocity
      vel.x = random(-2, 2);
      vel.y = -random(8, 12);
    }
  } else {
    // Original update code for other modes
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    
    // Wrap edges
    if (pos.x > width) pos.x = 0;
    if (pos.x < 0) pos.x = width;
    if (pos.y > height) pos.y = 0;
    if (pos.y < 0) pos.y = height;
  }
  
  lifespan *= decay;
}

    void setProperties(float maxSpeed, float decay, float strokeW) {
    this.maxSpeed = maxSpeed;
    this.decay = decay;
    this.strokeWeight = strokeW;
  }

    void show() {
    switch(renderMode) {
      case "point":
        stroke(colors.getColor(pos.x, pos.y), lifespan);
        strokeWeight(strokeWeight);
        point(pos.x, pos.y);
        break;
        
      case "line":
        stroke(colors.getColor(pos.x, pos.y), lifespan);
        strokeWeight(strokeWeight);
        line(pos.x, pos.y, pos.x + vel.x*5, pos.y + vel.y*5);
        break;
        
      case "circle":
        noStroke();
        fill(colors.getColor(pos.x, pos.y), lifespan);
        circle(pos.x, pos.y, strokeWeight * 2);
        break;
    }
  }

}
