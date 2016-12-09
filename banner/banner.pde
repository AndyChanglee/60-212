import processing.pdf.*;

String poem;
PFont font;

PGraphicsPDF pdf;

void setup() {
  size(800, 1000);
  
  pdf = (PGraphicsPDF) createGraphics(width, height, PDF, "banner.pdf");
  
  background(255);
  textSize(14);
  beginRecord(pdf);
  
  font = createFont("Why do we blink so frequently.ttf", 14);
  textFont(font);
  
  //Title Page
  String poemFile[] = loadStrings("title.txt");
  poem = poemFile[0];
  
  titlePage();
  for (int i = 0; i < titleLetters.length; i++) {
    if (titleLetters[i] != null) titleLetters[i].show();
  }
  pdf.nextPage();
  
  poemFile = loadStrings("poem.txt");
  poem = poemFile[0];
  poemCounter = 0;
}

Letter[] banner = new Letter[10000];

float t = 0;
float h = 0;
int frequency = 0;
int counter = 0;

int nextLetter = int(random(120,170));
float prevLetterY = 0;

boolean aboveScreenHeight = true;
boolean done = false;

int pagesDone = 0;
void draw() {
  if (poemCounter >= poem.length()) done = true;
  //bezier calculation
  noFill();
  float x1 = width * noise(t + 15); //anchor
  float x2 = width * noise(t + 35); //control
  float x3 = width * noise(t + 55); //control
  float x4 = width * noise(t + 75); //anchor
  float y1 = -height*5/8 + height * noise(t + 55) + h*500; //anchor
  float y2 = -height*5/8 + height * noise(t + 65) + h*500; //control
  float y3 = -height*5/8 + height * noise(t + 75) + h*500; //control
  float y4 = -height*5/8 + height * noise(t + 85) + h*500; //anchor
  //float z1 = noise(t + 15);
  //float z2 = noise(t + 25);
  //float z3 = noise(t + 35);
  //float z4 = noise(t + 45);
  noStroke();
  //bezier(x1, y1, x2, y2, x3, y3, x4, y4); //The calculated bezier

  t += 0.005;
  h += 0.005;
  int steps = 24;
  
  if (frequency % 4 == 0 && aboveScreenHeight) {
    for (int i = 0; i <= steps; i++) {
      float t = i / float(steps);
      
      float x = bezierPoint(x1, x2, x3, x4, t); 
      float y = bezierPoint(y1, y2, y3, y4, t);
      nextLetter --;
      if (!done && nextLetter <= 0) {
        banner[counter] = new Letter(x, y, true);
        nextLetter = int(random(10, 20));
        if (banner[counter].posY < prevLetterY + 40 || banner[counter].posY >= height) {
          banner[counter] = new Letter(x, y, false);
        }
        else prevLetterY = banner[counter].posY;
      }
      else {
        banner[counter] = new Letter(x, y, false);
        
      }
      counter ++;
    }
    
    //check if the last "row" of the banner is completely off screen.
    //If so, pdf screenshot and reset.
    int YCounter = 0;
    for (int i = 0; i < steps; i++) {
      if (banner[counter - 1 - i].posY > height) {
        YCounter ++;
      }
      if (YCounter == steps) {
        aboveScreenHeight = false;
      }
    }
  }
  frequency ++;
  
  //Just so I know it's working
  if (aboveScreenHeight) {
    background(255);
    fill(0);
    text("loading ... " + str(floor(banner[counter-1].posY / height * 100)) + "%", width/2, height/2);
    text("pages done: " + str(pagesDone), width/2, height/2 + 20);
  }
  
  if (!aboveScreenHeight) {
    background(255);
    for (int i = 0; i < banner.length; i++) {
      if (banner[i] != null) {
        banner[i].show();
      }
    }

    pdf.nextPage();
    
    pagesDone ++;
    
    //if book is finished, ie. poem is over
    if (done) {
      endRecord();
      noLoop();
      background(255);
      fill(0);
      text("Done!", width/2, height/2);
      delay(1500);
      exit();
    }
    //otherwise make a new page
    //reset values
    else {
      banner = new Letter[10000];
      
      counter = 0;
      frequency = 0;
      h = 0;
      
      nextLetter = int(random(100,150));
      prevLetterY = 0;
      
      aboveScreenHeight = true;
    }
  }
}

String alpha = "abcdefghijklmnopqrstuvwxyz";
int poemCounter;
//int lastPlaceInPoem = 0;
class Letter {
  float posX, posY;
  boolean nextInPoem;
  
  Letter(float x, float y, boolean inPoem) {
    posX = x;
    posY = y;
    nextInPoem = inPoem;
  }
  
  void show() {
    if (!nextInPoem || poemCounter >= poem.length()) {
      stroke(0, 0, 0, 30);
      fill(0, 0, 0, 30);
      textSize(14);
      text(alpha.charAt(int(random(alpha.length()))), posX, posY);
    }
    else {
      stroke(0, 0, 0, 255);
      fill(0, 0, 0, 255);
      textSize(14);
      text(poem.charAt(poemCounter), posX, posY);
      poemCounter ++;
    }
  }
}

Letter[] titleLetters = new Letter[10000];
void titlePage() {
  float row = 0;
  float col = 0;
  int nextInTitle = int(random(550, 750));
  for (int i = 0; i < titleLetters.length; i++) {
    if (nextInTitle <= 0) {
      titleLetters[i] = new Letter(col, row, true);
      nextInTitle = int(random(80, 160));
    }
    else titleLetters[i] = new Letter(col, row, false);
    col += 10;
    if (titleLetters[i].posX > width) {
      titleLetters[i].posX -= width;
      col = 0;
      row += 10;
    }
    nextInTitle --;
  }
}