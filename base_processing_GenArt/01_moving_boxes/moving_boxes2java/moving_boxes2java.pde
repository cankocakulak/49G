int numberOfSticks = 500;

Stick [] sticks = new Stick [numberOfSticks];

float t = 0;

boolean stopDraw = false;


void setup() {
  size(600, 600);
  background(100);
  frameRate(4);
  
  for (int ii = 0; ii < numberOfSticks; ii++) {
    float w = random(50);
    float l = random(150);
    float x = random(width-l);
    float y = random(height-w);
    int r = floor(random(255));
    int g = floor(random(255));
    int b = floor(random(255));
    
    sticks[ii] = new Stick(x,y,r,g,b,w,l);
  }
}


void draw() {
  if(!stopDraw){
    background(245);
    for (int ii=0; ii< numberOfSticks; ii++) {
      sticks[ii].show();
      sticks[ii].changeColor(t);
      float x_speed = map(noise(t),0,1,-1,1);
      float y_speed = map(noise(t+1000),0,1,-1, 1);
      sticks[ii].move(x_speed,y_speed);
      t += 0.01;
    }
  }
}

void keyPressed(){
  if (stopDraw){
    stopDraw = false;
  }
  else{
    stopDraw = true;
  }
}
