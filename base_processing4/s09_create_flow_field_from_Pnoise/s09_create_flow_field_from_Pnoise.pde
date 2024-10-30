FlowField flowfield;

boolean debug = true;

void setup() {
  size(600, 600);
  
  flowfield = new FlowField(20);
  flowfield.updateFF();
}

void draw() {
  background(245);
  flowfield.updateFF();
  
  if (debug) flowfield.display();
}
