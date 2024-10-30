class MovingParticle{
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float MAX_VELOCITY = 7;
  
  
  MovingParticle(float vel_x, float vel_y, float acc_x, float acc_y){
    position = new PVector(width/2, height/2);
    velocity = new PVector(vel_x, vel_y);
    acceleration = new PVector(acc_x, acc_y);
  }
  
  void updateAndMove(){
    acceleration = PVector.random2D();
    
    velocity.add(acceleration);
    velocity.limit(MAX_VELOCITY);
    position.add(velocity);
    
    checkEdges();
  }
  
  void checkEdges(){
    if (position.x>width){
      position.x = 0;
    }else if (position.x<0){
      position.x = width;
    }
    
    if (position.y>height){
      position.y = 0;
    }else if (position.y<0){
      position.y = height;
    }
  }
  
  void display(){
    stroke(0);
    fill(175);
    ellipse(position.x, position.y, 16,16);
  }
}
