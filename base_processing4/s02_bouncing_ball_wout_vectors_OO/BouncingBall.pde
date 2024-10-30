class BouncingBall{
float x; 
float y;
float xspeed; 
float yspeed;

BouncingBall(float px, float py, float pxspeed, float pyspeed){
  x = px;
  y = py;
  xspeed = pxspeed;
  yspeed = pyspeed;
}

void move(){
  x = x + xspeed;
  y = y + yspeed;
  bounce();
}

void bounce(){
  if ((x>width) || (x<0)){
    xspeed = xspeed * -1;
  }
  
  if ((y>height) || (y<0)){
    yspeed = yspeed * -1;
  }
}

void display(){
  // Display a circle at x,y
  stroke(0);
  strokeWeight(1.5);
  fill(127);
  ellipse(x,y,48,48);
}

}
