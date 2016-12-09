// This is a template for creating a looping animation in Processing. 
// When you press a key, this program will export a series of images
// into an "output" directory located in its sketch folder. 
// These can then be combined into an animated gif. 
// Known to work with Processing 3.0.1
// Prof. Golan Levin, September 2016
 
//===================================================
// Global variables. 
 
int     nFramesInLoop = 520;
int     nElapsedFrames;
boolean bRecording; 

Cube[] cubes = new Cube[200];

void setup(){
  size(800, 1000, P3D);
  
  bRecording = false;
  nElapsedFrames = 0;
  
  fill(255);
  strokeWeight(1);
  for (int i = 0; i < cubes.length; i++){
    cubes[i] = new Cube();
  }
}

void keyPressed() {
  bRecording = true;
  nElapsedFrames = 0;
}

void draw() {
  // Compute a percentage (0...1) representing where we are in the loop.
  float percentCompleteFraction = 0; 
  if (bRecording) {
    percentCompleteFraction = (float) nElapsedFrames / (float)nFramesInLoop;
  } else {
    percentCompleteFraction = (float) (frameCount % nFramesInLoop) / (float)nFramesInLoop;
  }
 
  // Render the design, based on that percentage. 
  renderMyDesign (percentCompleteFraction);
 
  // If we're recording the output, save the frame to a file. 
  if (bRecording) {
    saveFrame("outputgif/drewch-loop-" + nf(nElapsedFrames, 4) + ".png");
    nElapsedFrames++; 
    if (nElapsedFrames >= nFramesInLoop) {
      bRecording = false;
    }
  }
}

void renderMyDesign (float percent) {
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
  
  float cx = 100;
  float cy = 100;
  
  if (bRecording) {
    textAlign (CENTER); 
    String percentDisplayString = nf(percent, 1, 3);
    text (percentDisplayString, cx, cy-15);
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