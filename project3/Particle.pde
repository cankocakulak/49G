// Particle class: Represents individual particles that follow the flow field.
// Includes movement logic and rendering (with colors from the Colors class).


class Particle {
  PVector pos, vel, acc;
  float maxSpeed = 2;
  Colors colors;

  Particle(float x, float y, Colors c) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    colors = c;
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

  void show() {
    stroke(colors.getColor(pos.x, pos.y)); // Use color from Colors class
    point(pos.x, pos.y);
  }
}
