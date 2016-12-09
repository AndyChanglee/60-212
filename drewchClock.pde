// Waves
int cols, rows;
int scl = 20; //scale
int w, h;

float[][] wave;

float flyingX = 0;
float flyingY = 0;

Rain[] rain = new Rain[1000];
PVector gravity;

float wind = 0.13;
Cloud[] clouds = new Cloud[24];

void setup() {
  size(800, 800, P3D);
  w = 2000;
  h = 1300;
  cols = w / scl;
  rows = h / scl;
  wave = new float[cols][rows];
  
  gravity = new PVector(0, 0.4);
  
  //lol clouds
  clouds[0] = new Cloud(0, 100);
  clouds[1] = new Cloud(70, 90);
  clouds[2] = new Cloud(130, 100);
  clouds[3] = new Cloud(200, 95);
  clouds[4] = new Cloud(100, 0);
  clouds[5] = new Cloud(150, -10);
  clouds[6] = new Cloud(300, 110);
  clouds[7] = new Cloud(190, -50);
  clouds[8] = new Cloud(220, -50);
  clouds[9] = new Cloud(380, 100);
  clouds[10] = new Cloud(340, -150);
  clouds[11] = new Cloud(100, -150);
  clouds[12] = new Cloud(200, 100);
  clouds[13] = new Cloud(270, 90);
  clouds[14] = new Cloud(330, 100);
  clouds[15] = new Cloud(400, 95);
  clouds[16] = new Cloud(300, 0);
  clouds[17] = new Cloud(350, -10);
  clouds[18] = new Cloud(500, 110);
  clouds[19] = new Cloud(390, -50);
  clouds[20] = new Cloud(420, -50);
  clouds[21] = new Cloud(580, 100);
  clouds[22] = new Cloud(540, -150);
  clouds[23] = new Cloud(300, -150);
}

//Got help from Daniel Shiffman's 3D Terrain
void draw() {
  clear();
  background(21, 21, 41);
  

  //Rain
  //Add rain objects
  int k = 0;
  if (rain.length < 9950) {
    for (int i = 0; i < 17; i++) {
      if (k == 0 && rain[i] != null) {
        k = i;
        while(rain[k] != null){
          k++;
        }
        rain[k] = new Rain();
      }
      else if (rain[i] == null) {
        rain[k] = new Rain();
        k++;
      }
      else rain[i+k] = new Rain();
    }
  
    //Draw the rain
    pushStyle();
    rotate(degrees(-1.1)); //the wind
    for (int i = 0; i < rain.length; i++) {
      if (rain[i] != null) {
        stroke(155, 155, 155, int(random(100, 200)));
        if (rain[i].rainLength > 150) strokeWeight(2);
        else strokeWeight(1);
        line(rain[i].x, rain[i].y, rain[i].z, rain[i].x, rain[i].y + rain[i].rainLength, rain[i].z);
      }
    }
    popStyle();
    
    //Remove rain that has hit a threshold
    for (int i = 0; i < rain.length; i++) {
      if (rain[i] != null) {
        rain[i].descend();
        if (rain[i].y >= random(height*1/2, height)) {
          rain[i] = null;        
        }
      }
    }
  }
  
  rotate(degrees(1.1));
  float M = millis() * 0.00075;
  flyingX -= 0.005;
  flyingY -= 0.005;
  
  //Clouds
  noStroke();
  for (int i = 0; i < clouds.length; i++){  
    clouds[i].update(); 
  }
  
  //Waves
  
  float yoff = flyingY; //yoffset
  for (int y = 0; y < rows; y++) {
    float xoff = flyingX;
    for (int x = 0; x < cols; x++) {
      wave[x][y] = map(noise(xoff, yoff), 0, 1.4 + sin(M)/2, -50, 50 + sin(M)*2); //Make Waves Heave up and down, top 1 s, down 1 s
      xoff += 0.1;
    }
    yoff += 0.1;
  }
  
  stroke(255, 255, 255, 40);
  fill(2, 22, 43, 220);
  
  translate(width/2, height/2);
  rotateX(PI*4/9);
  
  translate(-w/2, -h/2);
  for (int y = 0; y < rows - 3; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
        vertex(x*scl, y*scl, wave[x][y]);
        vertex(x*scl, (y+1)*scl, wave[x][y + 1]);
    } 
    endShape();
  }
}

class Rain{
  float x, y, z, rainLength;
  
  Rain() {
    x = random(-200, width);
    y = random(-50, 0);
    z = random(0, 500);
    rainLength = random(50, 170);
  }
  
  void descend() {
    this.y += 40;
  }
}

class Cloud {
  float x, y;
  float xoff, yoff;
  float size;
  Circle[] lightCircles = new Circle[5];
  Circle[] darkCircles = new Circle[5];
  
  Cloud(float X, float Y) {
    x = X;
    y = Y;
    yoff = 50;
    size = random(125, 150);
    for (int i = 0; i < 5; i++) {
      lightCircles[i] = new Circle(random(x, x + 100), random(y, y + 100), size);
      darkCircles[i]  = new Circle(random(x, x + 100), random(y + yoff - 10, y + yoff + 70), size-10);
    }
  }
  
  void update() {
    noStroke();
    fill(200, 200, 200, 3);
    for (int i = 0; i < lightCircles.length; i++){
      ellipse(lightCircles[i].x, lightCircles[i].y, lightCircles[i].size, lightCircles[i].size);
      lightCircles[i].x += wind;
      if (lightCircles[i].x >= width) lightCircles[i].x = -50;
    }
    fill(10, 10, 10, 3);
    for (int i = 0; i < darkCircles.length; i++) {
      ellipse(darkCircles[i].x + wind, darkCircles[i].y, darkCircles[i].size, darkCircles[i].size);
      darkCircles[i].x += wind;
      if (darkCircles[i].x >= width) darkCircles[i].x = -50;
    }
  }
}

class Circle {
  float x, y, size;
  
  Circle(float X, float Y, float SIZE) {
    x = X;
    y = Y;
    size = SIZE;
  }
}