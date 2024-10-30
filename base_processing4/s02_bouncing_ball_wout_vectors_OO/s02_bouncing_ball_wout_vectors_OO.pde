BouncingBall bb1;
BouncingBall bb2;

void setup(){
  size(600, 600);
  background(151);  
  
  bb1 = new BouncingBall(width/3, height/3, 3.2, -4.2);
  bb2 = new BouncingBall(width/2, height/2, 3.2, -2.2);
}


void draw(){
  //background(151); 
  
  bb1.move();
  bb2.move();
  bb1.display();
  bb2.display();
}
