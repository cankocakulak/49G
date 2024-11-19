class MovingParticle{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float rand_acc_x;
  float rand_acc_y;
  float perlin_x_curr_time = 1;
  float perlin_y_curr_time = 15;
  float perlin_time_increment = 0.01;
  
  float perlin_red_curr_time = 1;
  float perlin_green_curr_time = 13;
  float perlin_blue_curr_time = 57;
  float perlin_color_time_increment = 0.005;
  
  float MAX_VELOCITY = 7;
  
  
  MovingParticle(float vel_x, float vel_y, float acc_x, float acc_y){
    position = new PVector(width/2, height/2);
    velocity = new PVector(vel_x, vel_y);
    acceleration = new PVector(acc_x, acc_y);
  }
  
  void updateAndMove(){
    //acceleration = PVector.random2D();
    acceleration = new PVector(2*noise(perlin_x_curr_time)-1, 2*noise(perlin_y_curr_time)-1);
    //acceleration.normalize();
    perlin_x_curr_time += perlin_time_increment;
    perlin_y_curr_time += perlin_time_increment;
    
    velocity.add(acceleration);
    velocity.limit(MAX_VELOCITY);
    //velocity = acceleration; 
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
    PVector rgb_vector = new PVector(round(255*noise(perlin_red_curr_time)), round(255*noise(perlin_green_curr_time)), round(255*noise(perlin_blue_curr_time)));
    perlin_red_curr_time += perlin_color_time_increment;
    perlin_green_curr_time += perlin_color_time_increment;
    perlin_blue_curr_time += perlin_color_time_increment;
    
    stroke(0);
    //fill(rgb_vector.x, rgb_vector.y, rgb_vector.z, 90);
    fill(rgb_vector.x, rgb_vector.y, rgb_vector.z);
    //noStroke();
    ellipse(position.x, position.y, 16,16);
  }
}
