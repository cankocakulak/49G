void setup(){
  size(600, 600);
}

void draw(){
  background(222);
  strokeWeight(2);
  stroke(0);
  noFill();
  
  // draw center point
  ellipse(width/2, height/2, 4, 4);
  
  PVector mouse = new PVector(mouseX, mouseY);
  PVector center = new PVector(width/2, height/2);
  
  stroke(0, 200, 100);
  line(0, 0, center.x, center.y);
  
  stroke(0, 100, 200);
  line(0, 0, mouse.x, mouse.y);
  
  stroke(200, 100, 100);
  //line(center.x, center.y, mouse.x, mouse.y);
  
  translate(width/2, height/2);
  mouse.sub(center);
  line(0, 0, mouse.x, mouse.y);
}
