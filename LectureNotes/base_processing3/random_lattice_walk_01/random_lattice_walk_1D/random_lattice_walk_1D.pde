
int current_sn = 5;
int hit_zero_cnt = 0;
int total_roll_cnt = 0;

void setup(){
  size(600, 600);
  background(255);
  frameRate(4);
}


void draw(){
  
  background(255);
  
  textSize(32);
  fill(0, 102, 153);
  
  
  float dice = random(1);
  total_roll_cnt++;
  
  if (dice < 0.5){
    current_sn--;
    text("Random Step = -1", 10, 30);
  }
  else{
    current_sn++;
    text("Random Step = +1", 10, 30);
  }
  
  text("Current Sn = "+Integer.valueOf(current_sn), 10, 70);
  
  if (current_sn==0){
    hit_zero_cnt++;
  }
  
  text("Current Hit = "+Integer.valueOf(hit_zero_cnt), 10, 110);
  text("Total Roll Count = "+Integer.valueOf(total_roll_cnt), 10, 150);
  
  //noLoop();
}
