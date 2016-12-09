Cube[] cubes = new Cube[50];

void setup(){
  size(800, 1000, P3D);
  
  noFill();
  strokeWeight(1);
  for (int i = 0; i < cubes.length; i++){
    cubes[i] = new Cube();
  }
}

void draw() {
  background(255);
  rotateY(-PI*1/8);
  for (int i = 0; i < cubes.length; i++){
    cubes[i].update();
  }
  
  for (int i = 0; i < cubes.length; i++){
    if (screenY(cubes[i].x, cubes[i].y, cubes[i].z) >= height+200){
      cubes[i] = new Cube();
    }
  }
}

class Cube {
  float x, y, z; //position of the cube
  float xr, yr; //the variables controlling initial rotation
  float dxr, dyr; //the rotation rate of xr and yr
  float vecX, vecY; //the variables controlling position
  
  float opacity = 0; //for fading in
  
  Cube() {
    x = random(-100, 0); //change these, ofc
    y = random(100, 200);
    z = random(-2000, 200);
    vecX = random(0.1, 0.8);
    vecY = random(0.1, 0.5);
    xr = random(0.01, 0.5);
    yr = random(0.01, 0.5);
    dxr = random(0.001, 0.01);
    dyr = random(0.001, 0.01);
  }
  
  void update() {
    if (opacity <= 255){
      opacity += 0.45;
    }
    else opacity = 255;
    xr += dxr;
    yr += dyr;
    x += vecX;
    y += vecY;
    vecY += 0.001;
    pushMatrix();
    stroke(255-floor(opacity));
    translate(x, y, z);
    rotateX(xr);
    rotateY(yr);
    box(120);
    popMatrix();
  }
}