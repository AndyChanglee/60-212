class Epicenter {
  ArrayList<Fracture> fractures = new ArrayList<Fracture>();
  ArrayList<Point> points = new ArrayList<Point>();

  Epicenter() {
    for (int i = 0; i < 100; i++) {
      points.add(new Point());
    }
    Fracture root = new Fracture(new PVector(width/2 + random(-5, 5), height/2 + random(-5, 5)), new PVector(random(-1, 1), random(-1, 1)));
    fractures.add(root);
    Fracture current = new Fracture(root);

    while (!closeEnough(current)) {
      Fracture trunk = new Fracture(current);
      fractures.add(trunk);
      current = trunk;
    }
  }

  boolean closeEnough(Fracture b) {
    for (Point l : points) {
      float d = PVector.dist(b.pos, l.pos);
      if (d < max_dist) {
        return true;
      }
    }
    return false;
  }

  void grow() {
    for (Point l : points) {
      Fracture closest = null;
      PVector closestDir = null;
      float record = -1;

      for (Fracture b : fractures) {
        PVector dir = PVector.sub(l.pos, b.pos);
        float d = dir.mag();
        if (d < min_dist) {
          l.reached();
          closest = null;
          break;
        } 
        else if (d > max_dist) {

        } 
        else if (closest == null || d < record) {
          closest = b;
          closestDir = dir;
          record = d;
        }
      }
      if (closest != null) {
        closestDir.normalize();
        closest.dir.add(closestDir);
        closest.count++;
      }
    }

    for (int i = points.size()-1; i >= 0; i--) {
      if (points.get(i).reached) {
        points.remove(i);
      }
    }

    for (int i = fractures.size()-1; i >= 0; i--) {
      Fracture b = fractures.get(i);
      if (b.count > 0) {
        b.dir.div(b.count);
        b.dir.normalize();
        Fracture newB = new Fracture(b);
        fractures.add(newB);
        b.reset();
      }
    }
  }

  void show() {
    /*
    for (Point l : points) {
      l.show();
    }
    */
    
    for (Fracture b : fractures) {
      if (b.parent != null) {
        stroke(255, 255, 255, 220);
        strokeWeight(1);
        line(b.pos.x, b.pos.y, b.parent.pos.x, b.parent.pos.y);
      }
    }
  }
}