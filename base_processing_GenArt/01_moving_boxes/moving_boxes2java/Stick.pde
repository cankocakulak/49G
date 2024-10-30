public class Stick{
  float x, y;
  int rcolor, gcolor, bcolor;
  float wwidth, llength;
  
  Stick(float px, float py, int pr, int pg, int pb, float pw, float pl){
    x = px;
    y = py;
    rcolor = pr;
    gcolor = pg;
    bcolor = pb;
    wwidth = pw;
    llength = pl;
  }
  
  void show(){
    fill(this.rcolor, this.gcolor, this.bcolor);
    rect(this.x, this.y, this.llength, this.wwidth);
  }
  
  void changeColor(float t){
    float cr = noise(t+2);
    float cg = noise(t+100);
    float cb = noise(t+222);
    this.rcolor = floor(map(cr, 0,1, 0,255));
    this.gcolor = floor(map(cg, 0,1, 0,255));
    this.bcolor = floor(map(cb, 0,1, 0,255));
  }
  
  void move(float x_speed, float y_speed){
    this.x += x_speed;
    this.y += y_speed;
  }
}
