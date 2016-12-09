//A bug surfaced during translation from p5.js to processing and some intersections dont appear. God have mercy.


void setup() {
  size(600, 600);
}


void draw() {
}

// Line Class
class Line {
  float X1, Y1, X2, Y2, m, b;
  String equation;
  Line(float x1, float y1, float x2, float y2) {
    X1 = x1;
    Y1 = y1;
    X2 = x2;
    Y2 = y2;
    m = -1 * ((y2-y1) / (x2-x1)); // y is reversed in computer science
    //y = mx + b
    //b = y - mx
    b = -1 * (y1) - (m * x1);
    equation = "y = " + m + "x + " + b;
  }
}

// Circle Class
class Circle {
  float X;
  float Y;
  
  Circle(float x, float y){
    X = x;
    Y = y;
  }
  
  void display() {
    float r = random(50, 70);
    strokeWeight(0);
    fill(255, 0, 0, 50);
    ellipse(X, Y, r, r);
  }
}

void mousePressed() {
  clear();
  background(255);
  int amountOfLines = int(random(5, 8));
  Line[] lineArray = new Line[100];
  Circle[] circleArray = new Circle[100];
  
  for (int i = 0; i <= amountOfLines; i+= 1) {
    float x1 = random(0, width);
    float y1 = random(0, height);
    float x2 = random(0, width);
    float y2 = random(0, height);
    strokeWeight(2);
    line(x1, y1, x2, y2);
    lineArray[i] = new Line(x1, y1, x2, y2);
  }
  // m1x + b1 = m2x + b2
  // m1x - m2x = b2 - b1
  // x (m1 - m2) = b2 - b1
  // x = (b2 - b1) / (m1 - m2)
  // then plug in x to find y in y = mx + b for (x, y) intersection
  float x = 0;
  float y = 0;
  int arrayCheck = 0;
  for (int l1 = 0; l1 < amountOfLines - 1; l1++) {
    for (int l2 = l1 + 1; l2 < amountOfLines; l2++) {
      //Bounding Box intersection
      if (min(lineArray[l1].X1, lineArray[l1].X2) < max(lineArray[l2].X1, lineArray[l2].X2) && 
          max(lineArray[l1].X1, lineArray[l1].X2) > min(lineArray[l2].X1, lineArray[l2].X2) &&
          min(lineArray[l1].Y1, lineArray[l1].Y2) < max(lineArray[l2].Y1, lineArray[l2].Y2) &&
          max(lineArray[l1].Y1, lineArray[l1].Y2) > min(lineArray[l2].Y1, lineArray[l2].Y2)) {
            
            x = (lineArray[l2].b - lineArray[l1].b) / (lineArray[l1].m - lineArray[l2].m);
            y = -1 * ((lineArray[l1].m * x) + lineArray[l1].b); // (x, y) intersect on first line segment
            //jesus, line equation with inversed y is so confusing
            
            if (!(x < min(lineArray[l1].X1, lineArray[l1].X2) || x > max(lineArray[l1].X1, lineArray[l1].X2) ||
                  y < min(lineArray[l1].Y1, lineArray[l1].Y2) || y > max(lineArray[l1].Y1, lineArray[l1].Y2) ||
                  x < min(lineArray[l2].X1, lineArray[l2].X2) || x > max(lineArray[l2].X1, lineArray[l2].X2) ||
                  y < min(lineArray[l2].Y1, lineArray[l2].Y2) || y > max(lineArray[l2].Y1, lineArray[l2].Y2)))  {
                
                circleArray[arrayCheck] = new Circle(x, y);
                arrayCheck++;
            }
      }
    }
  }
  for (int k = 0; k < arrayCheck; k++) {
    circleArray[k].display();
  }
  //console.log(circleArray)
}