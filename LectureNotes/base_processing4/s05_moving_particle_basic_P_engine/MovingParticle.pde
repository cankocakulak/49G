class MovingParticle{
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float MAX_VELOCITY = 20;
  
  MovingParticle(float vel_x, float vel_y, float acc_x, float acc_y){
    position = new PVector(width/2, height/2);
    velocity = new PVector(vel_x, vel_y);
    acceleration = new PVector(acc_x, acc_y);
  }
  
  void moveAndUpdate(){
    velocity.add(acceleration);
    velocity.limit(MAX_VELOCITY);
    position.add(velocity);
    bounce();
  }
  
  void bounce(){
    if ((position.x>width) || (position.x<0)){
      velocity.x = velocity.x * -1;
      acceleration.x = acceleration.x * -0.6;
    }
    if ((position.y>height) || (position.y<0)){
      velocity.y = velocity.y * -1;
      acceleration.y = acceleration.y * -0.6;
    }
  }
  
  void display(){
    stroke(0);
    fill(175);
    ellipse(position.x, position.y, 16,16);
  }
}
