class MovingParticle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float mass = 10;

  float MAX_VELOCITY = 7;


  MovingParticle(float xpos, float ypos, float vel_x, float vel_y, float acc_x, float acc_y, float pmass) {
    position = new PVector(xpos, ypos);
    velocity = new PVector(vel_x, vel_y);
    acceleration = new PVector(acc_x, acc_y);
    mass = pmass;
  }

  void update() {

    velocity.add(acceleration);
    velocity.limit(MAX_VELOCITY);
    position.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    PVector acc = PVector.div(force, mass);
    // In stead of setting the magnitude directly
    // We add the force, to be able to apply multiple forces
    acceleration.add(acc); 
    //acceleration.set(force.x, force.y);
  }

  void display() {
    stroke(0);
    fill(175);
    ellipse(position.x, position.y, 2*sqrt(mass), 2*sqrt(mass));
  }
}
