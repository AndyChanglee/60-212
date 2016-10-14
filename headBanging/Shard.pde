class Shard {
  PVector[] vertexes = new PVector[int(random(3, 10))];
  PVector vel = new PVector(random(-10, 10), random(random(0, 20)));
  PVector acc = new PVector(0, 0.8);
  float rotX = random(-1, 1);
  float rotY = random(-1, 1);
  float rotZ = random(-1, 1);
  
  Shard() {
    for (int i = 0; i < vertexes.length; i++){
      vertexes[i] = new PVector(random(-20, width/10 +20), random(-20, height/10 + 20));
    }
  }
  
  void update() {
    for (int i = 0; i < vertexes.length; i++){
      vertexes[i].add(vel);
    }
    vel.add(acc);
  }
  
  void show(int col, int row) {
    pushMatrix();
    translate(col * width/10, row * height/10);
    rotateX(rotX);
    rotateY(rotY);
    rotateZ(rotZ);
    fill(51, 51, 81, 220);
    noStroke();
    beginShape();
    for (int i = 0; i < vertexes.length; i++){
      vertex(vertexes[i].x, vertexes[i].y);
    }
    endShape(CLOSE);
    popMatrix();
  }
}