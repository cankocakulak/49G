public class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector previousPos;
  float maxSpeed;
  int r, g, b;
  int cnt;

  Particle(PVector start, float maxspeed, int pr, int pg, int pb) {
    maxSpeed = maxspeed;
    pos = start;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    previousPos = pos.copy();
    r = pr;
    g = pg;
    b = pb;
    cnt = 0;
  }

  void run() {
    updatePosition();
    edges();
    show();
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
    PVector diverge = new PVector(pos.x - width/2,  pos.y - height/2);
    if ((pos.x - width/2) * (pos.x - width/2) + (pos.y - height/2)* (pos.y - height/2) < 10000) {
      diverge.setMag(10);
      applyForce(diverge);
    }
    PVector converge = new PVector(- pos.x + width/2-10,  - pos.y + height/2);
    converge.setMag(0.5);
    applyForce(converge);
    PVector gravity = new PVector(0,  1);
    gravity.setMag(0.5);
    //applyForce(gravity);



   
  }

  void show() {
    if (isDrawingTrace)
      stroke(r, g, b, 15);
    else
      stroke(r, g, b, 225);
    //strokeWeight(3);
    strokeWeight(1);
    strokeCap(SQUARE);
    line(pos.x, pos.y, previousPos.x, previousPos.y);
    cnt++;
    updatePreviousPos();

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
