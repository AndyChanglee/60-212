import java.util.List;

class PBvh
{
  BvhParser parser;  

  PBvh(String[] data) {
    parser = new BvhParser();
    parser.init();
    parser.parse( data );
  }

  void update( int ms ) {
    parser.moveMsTo( ms );//30-sec loop 
    parser.update();
  }

  //------------------------------------------------
  public Sand[] sand = new Sand[50000];
  public int sandCounter = 0;
  public int frequency = 0;
  int c;
  void draw() {
    background(0);
    colorMode(HSB);
    if (c >= 255)  c=0;
    else  c++;
    // Previous method of drawing, provided by Rhizomatiks/Perfume
    
    fill(c, 255, 255);

    strokeWeight(4);
    frequency ++;
    
      for ( BvhBone b : parser.getBones()) {
        if (frequency % 1 == 0) {
          if (!b.hasChildren()) {
            pushMatrix();
            //translate(b.absEndPos.x, b.absEndPos.y, b.absEndPos.z);
            sand[sandCounter] = new Sand(b.absEndPos.x, b.absEndPos.y, b.absEndPos.z, c);
            popMatrix();
          }
          else {
            pushMatrix();
            //translate(b.absPos.x, b.absPos.y, b.absPos.z);
            sand[sandCounter] = new Sand(b.absPos.x, b.absPos.y, b.absPos.z, c);
            popMatrix();
          }
        }
      }
      for(int i = 0; i < sand.length; i++) {
        if (sand[i] != null){
          sand[i].update();
          if (!sand[i].alive) {
            sand[i] = null;
          }
          
        }
      }
  }
  
  public class Sand{
    PVector pos = new PVector(0, 0, 0);
    PVector acc = new PVector(0, -0.08, 0);
    PVector vel = new PVector(random(-1, 1), 0, random(-1, 1));
    int marbleColor;
    float marbleOpacity = 255;
    
    int lifetime = 150;
    boolean alive = true;
    
    Sand(float x, float y , float z, int c) {
      sandCounter ++;
      pos.set(x, y, z);
      marbleColor = c;
      if(sandCounter >= 49999) sandCounter = 0;
    }
    
    void update() {
      vel.add(acc);
      pos.add(vel);
      pushStyle();
      pushMatrix();
        strokeWeight(.04 * (pos.z/2));
        stroke(marbleColor, 255, pos.z, int(marbleOpacity));
        point(pos.x, pos.y, pos.z);
      popStyle();
      popMatrix();
      if (pos.y <= 0) {
        vel.set(vel.x, (-1 * vel.y) * 0.4, vel.z);
      }
      lifetime --;
      if (lifetime <= 100) marbleOpacity -= 3;
      if (lifetime <= 0) alive = false;
    }
  }

  //------------------------------------------------
  // Alternate method of drawing, added by Golan
  void drawBones() {
    noFill(); 
    stroke(255); 
    strokeWeight(2);

    List<BvhBone> theBvhBones = parser.getBones();
    int nBones = theBvhBones.size();       // How many bones are there?
    for (int i=0; i<nBones; i++) {         // Loop over all the bones
      BvhBone aBone = theBvhBones.get(i);  // Get the i'th bone

      PVector boneCoord0 = aBone.absPos;   // Get its start point
      float x0 = boneCoord0.x;             // Get the (x,y,z) values 
      float y0 = boneCoord0.y;             // of its start point
      float z0 = boneCoord0.z;

      if (aBone.hasChildren()) {           

        // If this bone has children, 
        // draw a line from this bone to each of its children
        List<BvhBone> childBvhBones = aBone.getChildren(); 
        int nChildren = childBvhBones.size();
        for (int j=0; j<nChildren; j++) {
          BvhBone aChildBone = childBvhBones.get(j); 
          PVector boneCoord1 = aChildBone.absPos;

          float x1 = boneCoord1.x;
          float y1 = boneCoord1.y;
          float z1 = boneCoord1.z;

          line(x0, y0, z0, x1, y1, z1);
        }
      } else {
        // Otherwise, if this bone has no children (it's a terminus)
        // then draw it differently. 

        PVector boneCoord1 = aBone.absEndPos;  // Get its start point
        float x1 = boneCoord1.x;
        float y1 = boneCoord1.y;
        float z1 = boneCoord1.z;

        line(x0, y0, z0, x1, y1, z1);

        String boneName = aBone.getName(); 
        if (boneName.equals("Head")) { 
          pushMatrix();
          translate( x1, y1, z1);
          ellipse(0, 0, 30, 30);
          popMatrix();
        }
      }
    }
  }
}