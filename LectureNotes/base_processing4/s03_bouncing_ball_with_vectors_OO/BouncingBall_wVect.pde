class BouncingBall_wVect{
  PVector position;
  PVector velocity;

BouncingBall_wVect(){
  position = new PVector(width/2, height/2);
  velocity = new PVector(3.2, -2.2);
}

void move(){
  position.add(velocity);
  bounce();
}

void bounce(){
  if ((position.x>width) || (position.x<0)){
    velocity.x = velocity.x * -1;
  }
  
  if ((position.y>height) || (position.y<0)){
    velocity.y = velocity.y * -1;
  }
}

void display(){
  // Display a circle at x,y
  stroke(0);
  strokeWeight(1.5);
  fill(127);
  ellipse(position.x, position.y, 48, 48);
}

}
