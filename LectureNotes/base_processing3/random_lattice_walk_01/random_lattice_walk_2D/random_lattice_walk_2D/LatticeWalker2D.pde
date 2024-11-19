
class LatticeWalker2D{
  int x, y;
  int size = 2;
  
  // Constructer
  LatticeWalker2D(int psize){
    x = width/2;
    y = height/2;
    size = psize;
  }
  
  void render(){
    stroke(0, 75);
    fill(204, 102, 0, 50);
    circle(x,y, size-1);
  }
  
  void walk(){
    float dice = random(1);
    
    if (dice < 0.25){
      x+=size;
    } 
    else if (dice < 0.5){
      x-=size;
    }
    else if (dice < 0.75){
      y+=size;
    }
    else{
      y-=size;
    }
    
    x = constrain(x, 0, width-size);
    y = constrain(y, 0, height-size);
  }
  
}
