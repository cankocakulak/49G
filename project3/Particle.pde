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

      float angle;  // Declare angle once at the start
      float radius;
      float angleToCenter;
    PVector target;
    PVector direction;

      switch(movementMode) {
        case "fountain":
          // Fountain movement
          vel.y += 0.2;  // gravity
          pos.add(vel);
          if (pos.y > height) {
            pos.x = width/2 + random(-20, 20);
            pos.y = height;
            vel.x = random(-2, 2);
            vel.y = -random(8, 12);
          }
          break;        
        
        case "rain":
          // Rain movement
          vel.y = maxSpeed;  // constant downward
          vel.x += random(-0.1, 0.1);  // slight sideways drift
          pos.add(vel);
          if (pos.y > height) {
            pos.y = 0;
            pos.x = random(width);
          }
          break;

        case "triangle_converge":
          // Target is center of screen
          target = new PVector(width/2, height/2);
          
          // Calculate direction to target
          direction = PVector.sub(target, pos);
          
          // Normalize and scale by maxSpeed
          direction.normalize();
          direction.mult(maxSpeed);
          
          // Gradually move towards target
          vel.lerp(direction, 0.1);
          pos.add(vel);
          
          // Reset if too close to center or off screen
          if (PVector.dist(pos, target) < 10 || pos.y < 0) {
              // Respawn along bottom edge
              pos.x = random(width);
              pos.y = height;
              // Initial velocity pointing upward and inward
              angleToCenter = atan2(target.y - height, target.x - pos.x);
              vel = PVector.fromAngle(angleToCenter);
              vel.mult(maxSpeed);
          }
          break;
          
      
          case "triangle_top":
              // Target is center of screen
              target = new PVector(width/2, height/2);
              
              // Calculate direction to target
              direction = PVector.sub(target, pos);
              
              // Normalize and scale by maxSpeed
              direction.normalize();
              direction.mult(maxSpeed);
              
              // Gradually move towards target
              vel.lerp(direction, 0.1);
              pos.add(vel);
              
              // Reset if too close to center or off screen
              if (PVector.dist(pos, target) < 10 || pos.y > height) {
                  // Respawn along top edge
                  pos.x = random(width);
                  pos.y = 0;
                  // Initial velocity pointing downward and inward
                  angleToCenter = atan2(target.y, target.x - pos.x);
                  vel = PVector.fromAngle(angleToCenter);
                  vel.mult(maxSpeed);
              }
              break;

        case "triangle_left":
          // Target is center of screen
          target = new PVector(width/2, height/2);
          
          // Calculate direction to target
          direction = PVector.sub(target, pos);
          
          // Normalize and scale by maxSpeed
          direction.normalize();
          direction.mult(maxSpeed);
          
          // Gradually move towards target
          vel.lerp(direction, 0.1);
          pos.add(vel);
        
          // Reset if too close to center or off screen
          if (PVector.dist(pos, target) < 10 || pos.x > width) {
              // Respawn along left edge
              pos.x = 0;
              pos.y = random(height);
              // Calculate angle from left edge to center
              float dx = target.x - pos.x;
              float dy = target.y - pos.y;
              angleToCenter = atan2(dy, dx);  // Simplified angle calculation
              vel = PVector.fromAngle(angleToCenter);
              vel.mult(maxSpeed);
          }
          break;

        case "triangle_right":
          // Target is center of screen
          target = new PVector(width/2, height/2);
          
          // Calculate direction to target
          direction = PVector.sub(target, pos);
          
          // Normalize and scale by maxSpeed
          direction.normalize();
          direction.mult(maxSpeed);
          
          // Gradually move towards target
          vel.lerp(direction, 0.1);
          pos.add(vel);
          
          // Reset if too close to center or off screen
          if (PVector.dist(pos, target) < 10 || pos.x < 0) {
              // Respawn along right edge
              pos.x = width;
              pos.y = random(height);
              // Calculate angle from right edge to center
              float dx = target.x - pos.x;
              float dy = target.y - pos.y;
              angleToCenter = atan2(dy, dx);  // Simplified angle calculation
              vel = PVector.fromAngle(angleToCenter);
              vel.mult(maxSpeed);
          }
          break;

        case "spiral":
          // Spiral movement
          angle = atan2(pos.y - height/2, pos.x - width/2);
          radius = dist(pos.x, pos.y, width/2, height/2);
          vel.x = cos(angle + 0.1) * maxSpeed;
          vel.y = sin(angle + 0.1) * maxSpeed;
          pos.add(vel);
          break;
          
        case "firework":
          // Firework movement
          vel.y += 0.1;  // gravity
          pos.add(vel);
          if (pos.y > height) {
            pos.y = height/2;
            pos.x = width/2;
            angle = random(TWO_PI);
            vel.x = cos(angle) * random(2, 5);
            vel.y = sin(angle) * random(-8, -4);
          }
          break;
          
        case "curtain":
          // Curtain movement
          vel.y = maxSpeed * 0.5;
          vel.x = sin(pos.y * 0.02) * 2;
          pos.add(vel);
          if (pos.y > height) {
            pos.y = 0;
            pos.x = random(width);
          }
          break;
          
        case "vortex":
          // Vortex movement
          PVector center = new PVector(width/2, height/2);
          PVector toCenter = PVector.sub(center, pos);
          angle = atan2(toCenter.y, toCenter.x);
          vel.x = cos(angle) * maxSpeed;
          vel.y = sin(angle) * maxSpeed;
          pos.add(vel);
          break;
          
        case "flow":
     
        default:
          // Default flow movement
          vel.add(acc);
          vel.limit(maxSpeed);
          pos.add(vel);
          acc.mult(0);
          
          // Wrap edges
          if (pos.x > width) pos.x = 0;
          if (pos.x < 0) pos.x = width;
          if (pos.y > height) pos.y = 0;
          if (pos.y < 0) pos.y = height;
          break;
      }
      
      lifespan *= decay;
    }
  
    Particle copy() {
      Particle p = new Particle(pos.x, pos.y, colors, renderMode, movementMode);
      p.vel = vel.copy();
      p.acc = acc.copy();
      p.maxSpeed = maxSpeed;
      p.lifespan = lifespan;
      p.decay = decay;
      p.strokeWeight = strokeWeight;
      return p;
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
