class GaussianWalker3D{
  float x, y, z;
  
  float diCo_micrometerSq_per_sec;
  float delta_t_sec;
  
  float step_stdev;
  
  // Constructer
  GaussianWalker3D(float p_diCo_micrometerSq_per_sec, float p_delta_t_sec){
    x = width/2;
    y = height/2;
    z = 0;
    diCo_micrometerSq_per_sec = p_diCo_micrometerSq_per_sec;
    delta_t_sec = p_delta_t_sec;
    step_stdev = sqrt(2*diCo_micrometerSq_per_sec*delta_t_sec);
  }
  
  float get_x(){
    return x;
  }
  
  float get_y(){
    return y;
  }
  
  float get_z(){
    return z;
  }
  
  void walk(){
    float delta_x = randomGaussian()*step_stdev;
    float delta_y = randomGaussian()*step_stdev;
    float delta_z = randomGaussian()*step_stdev;
    
    x += delta_x;
    y += delta_y;
    z += delta_z;
    
    x = constrain(x, 0, width-1);
    y = constrain(y, 0, height-1);
  }
  
}
