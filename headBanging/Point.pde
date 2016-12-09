class Point {
  PVector pos;
  boolean reached = false;

  Point() {
    pos = PVector.random2D();
    pos.mult(random(width - 10));
    pos.x += width/2;
    pos.y += height/2;
  }

  void reached() {
    reached = true;
  }

  void show() {
    fill(255);
    noStroke();
    ellipse(pos.x, pos.y, 2, 2);
  }
}