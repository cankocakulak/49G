float x;
float y;

float xspeed = 3.2;
float yspeed = -2.2;

void setup(){
  size(600, 600);
  background(151);  
  x = width/2;
  y = height/2;
}

void draw(){
  //background(151); 
  x = x + xspeed;
  y = y + yspeed;
  
  if ((x>width) || (x<0)){
    xspeed = xspeed * -1;
  }
  
  if ((y>height) || (y<0)){
    yspeed = yspeed * -1;
  }
  
  // Display a circle at x,y
  stroke(0);
  strokeWeight(1.5);
  fill(127);
  ellipse(x,y,48,48);
}
