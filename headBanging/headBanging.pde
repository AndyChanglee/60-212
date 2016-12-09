//Code adapted from Dan Shiffman's Space Colonization

import oscP5.*;
OscP5 oscP5;

// num faces found
int found;

// pose
float poseScale;

import processing.sound.*;
SoundFile sound1, sound2, sound3, sound4, sound5, sound6;
SoundFile shatterSound;
SoundFile[] sounds = new SoundFile[6];

Epicenter[] cracks = new Epicenter[10];
float min_dist = 100;
float max_dist = 1000;

int maxHP = 5;
int wallHP = maxHP;
boolean shattered = false;
float opacity = 255;

Shard[] shards = new Shard[100];

void setup() {
  size(800, 800, P3D);
  background(255);
  lightFalloff(1.0, 0.001, 0.0);
  
  sound1 = new SoundFile(this, "sound1.wav");
  sound2 = new SoundFile(this, "sound2.wav");
  sound3 = new SoundFile(this, "sound3.wav");
  sound4 = new SoundFile(this, "sound4.wav");
  sound5 = new SoundFile(this, "sound5.wav");
  sound6 = new SoundFile(this, "sound6.wav");
  shatterSound = new SoundFile(this, "shatterSound.wav");
  
  sounds[0] = sound1;
  sounds[1] = sound2;
  sounds[2] = sound3;
  sounds[3] = sound4;
  sounds[4] = sound5;
  sounds[5] = sound6;
  
  for (int i = 0; i < shards.length; i++) {
    shards[i] = new Shard();
  }
  
  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseScale", "/pose/scale");
}


float glassOpacity = 0;
float minScale = 10;
float maxScale = 0;
int rest = 0;
void draw() {
  background(255);
  pointLight(250, 250, 250, 0, 0, 10);
  
  if (!shattered) {
    if (glassOpacity < 180) glassOpacity += 1;
    pushMatrix();
    noStroke();
    fill(51, 51, 101, glassOpacity);
    beginShape();
      vertex(0, 0, -50);
      vertex(width, 0, -50);
      vertex(width, height, -50);
      vertex(0, height, -50);
    endShape(CLOSE);
    popMatrix();
    
    for (int i = 0; i < cracks.length; i++) {
      if (cracks[i] != null) {
        cracks[i].show();
        for (int k = 0; k < 10; k++) {
          cracks[i].grow();
        }
      }
    }
  }
  
  //resets a bunch of stuff
  if (shattered) {
    int i = 0;
    for (int col = 0; col < width/80; col++) {
      for (int row = 0; row < height/80; row++) {
        fill(opacity);
        shards[i].show(col, row);
        i++;
      }
    }
    
    for (int k = 0; k < shards.length; k++) {
      shards[k].update();
    }
    
    opacity -= 1.5;
    if (opacity <= 0) {
      for (int j = 0; j < cracks.length; j++) {
        cracks[j] = null;
      }
      for (int l = 0; l < shards.length; l++) {
        shards[l] = new Shard();
      }
      opacity = 255;
      glassOpacity = 0;
      shattered = false;
      minScale = 10;
      maxScale = 0;
    }
  }
  
  if (minScale > poseScale && rest > 60) minScale = poseScale;
  if (maxScale < poseScale && rest > 60) maxScale = poseScale;
  
  if (headBanged() && rest > 60){
    bang();
    rest = 0;
    minScale = 10;
    maxScale = 0;
  }
  rest += 1;
}

boolean headBanged() {
  if (maxScale-minScale >= 2.5) return true;
  return false;
}

void bang() {
  wallHP--;
  if (wallHP <= 0) {
    shattered = true;
    wallHP = maxHP;
  }
  if (!shattered) sounds[int(random(0, 6))].play();
  else shatterSound.play();
  
  int i = 0;
  boolean newCrack = false;
  while (!newCrack && i < cracks.length) {
    if (cracks[i] == null) {
      cracks[i] = new Epicenter();
      cracks[i+1] = new Epicenter();
      newCrack = true;
    }
    i++;
  }
}

// OSC CALLBACK FUNCTIONS

public void found(int i) {
  println("found: " + i);
  found = i;
}

public void poseScale(float s) {
  println("scale: " + s);
  poseScale = s;
}