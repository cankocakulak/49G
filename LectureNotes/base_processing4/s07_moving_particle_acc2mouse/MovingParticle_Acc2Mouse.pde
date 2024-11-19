class MovingParticle_Acc2Mouse{
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float MAX_VELOCITY = 7;
  
  
  MovingParticle_Acc2Mouse(float vel_x, float vel_y, float acc_x, float acc_y){
    position = new PVector(width/2, height/2);
    velocity = new PVector(vel_x, vel_y);
    acceleration = new PVector(acc_x, acc_y);
  }
  
  void update(){
    PVector mouse = new PVector(mouseX, mouseY);
    mouse.sub(position);
    mouse.mult(0.1);
    acceleration = mouse;
    
    velocity.add(acceleration);
    velocity.limit(MAX_VELOCITY);
    position.add(velocity);
  }
  
  
  void display(){
    stroke(0);
    fill(175);
    ellipse(position.x, position.y, 16,16);
  }
}
