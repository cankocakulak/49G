public class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector previousPos;
  float maxSpeed;
  int r, g, b;
  int lifeTime = 100;
  float inc;
  float mass=1;
  Particle(PVector start, float maxspeed, int pr, int pg, int pb) {
    maxSpeed = maxspeed;
    pos = start;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    previousPos = pos.copy();
    r = pr;
    g = pg;
    b = pb;
    inc=1;
  }
  void run() {
    updatePosition();
    edges();
    show(r, g, b);
  }
  void updatePosition() {
    pos.add(vel);
    vel.add(acc);
    vel.limit(maxSpeed);
    acc.mult(0);
  }
  void applyForce(PVector force) {
    acc.add(force);
  }
  void applyFieldForce(FlowField flowfield) {
    int x = floor(pos.x / flowfield.scl);
    int y = floor(pos.y / flowfield.scl);
    PVector force = flowfield.vectors[x][y];
    applyForce(force);
    //setColor(floor(noise(x, y, inc)*500),floor(random(100)),floor(random(20)));
  }
  void show(int r, int g, int b) {
    if (isDrawingTrace) {
      strokeWeight(1);
      stroke(r, g, b, 10);
    } else {
      strokeWeight(1);
      stroke(r, g, b, 10);
    }
    //strokeWeight(3);
    line(pos.x, pos.y, previousPos.x, previousPos.y);
    //point(pos.x, pos.y);
    updatePreviousPos();
    lifeTime--;
  }
  int getLifeTime() {
    return lifeTime;
  }
  void setLifeTime(int setLifeTime) {
    lifeTime= setLifeTime;
  }
  void setColor(int pr, int pg, int pb) {
    r = pr;
    g = pg;
    b = pb;
  }
  void updatePreviousPos() {
    this.previousPos.x = pos.x;
    this.previousPos.y = pos.y;
  }
  void edges() {
    if (pos.x > width) {
      pos.x = 0;//10*width-9*pos.x;
      updatePreviousPos();
    }
    if (pos.x < 0) {
      pos.x = width;//-9*pos.x;
      updatePreviousPos();
    }
    if (pos.y > height) {
      pos.y = 0;//10*height-9*pos.y;
      updatePreviousPos();
    }
    if (pos.y < 0) {
      pos.y = height;//-9*pos.y;
      updatePreviousPos();
    }
  }
}
