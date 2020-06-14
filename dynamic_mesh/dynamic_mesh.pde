//import com.hamoid.*;
//VideoExport videoExport;
class Grid {
  float K;
  float L;
  Node [][] nodes;
  float strutLength;
  PVector dims;
  boolean display;
  color a=color(0, 0, 255, 64);
  color b=color(0, 200, 255, 255);
  Grid(PVector dims, float strutLength) {
    display=false;
    K=0.2;
    L=0;
    this.dims = dims;
    nodes=new Node[(int)dims.x][(int)dims.y];
    this.strutLength = strutLength;
    for (int i=0; i<dims.x; i++) {
      for (int j=0; j<dims.y; j++) {
        float inverseMass = 0.12;
        if ((i==0)||(j==0)||(i==dims.x-1)||(j==dims.y-1)) {
          inverseMass=0;
        }
        nodes[i][j] = new Node(PVector.mult(new PVector(i, j), strutLength), inverseMass);
      }
    }
  }
  void display() {
    strokeWeight(1);
    for (int i=0; i<dims.x-1; i++) {
      for (int j=0; j<dims.y-1; j++) {
        //if (onscreen(nodes[i][j].position.x, nodes[i][j].position.y)) {
        stroke(lerpColor(a, b, map(nodes[i][j].displacement.mag(), 0, 100, 0, 1)));
        //stroke(255);
        line(nodes[i][j].position.x, nodes[i][j].position.y, nodes[i+1][j].position.x, nodes[i+1][j].position.y);
        line(nodes[i][j].position.x, nodes[i][j].position.y, nodes[i][j+1].position.x, nodes[i][j+1].position.y);
        if (i==dims.x-2) {
          line(nodes[i+1][j].position.x, nodes[i+1][j].position.y, nodes[i+1][j+1].position.x, nodes[i+1][j+1].position.y);
        }
        if (j==dims.y-2) {
          line(nodes[i][j+1].position.x, nodes[i][j+1].position.y, nodes[i+1][j+1].position.x, nodes[i+1][j+1].position.y);
        }
        //}
      }
    }
  }
  void update() {
    for (int i=0; i<dims.x; i++) {
      for (int j=0; j<dims.y; j++) {
        //if (onscreen(nodes[i][j].position.x, nodes[i][j].position.y)) {
        PVector nodePosition = new PVector(nodes[i][j].position.x, nodes[i][j].position.y);
        nodes[i][j].netForce.set(0, 0);
        if (j>0) {
          nodes[i][j].netForce.add(applyForce(nodePosition, nodes[i][j-1].position, nodes[i][j-1].acceleration));
        }
        if (i<dims.x-1) {
          nodes[i][j].netForce.add(applyForce(nodePosition, nodes[i+1][j].position, nodes[i+1][j].acceleration));
        }
        if (i>0) {
          nodes[i][j].netForce.add(applyForce(nodePosition, nodes[i-1][j].position, nodes[i-1][j].acceleration));
        }
        if (j<dims.y-1) {
          nodes[i][j].netForce.add(applyForce(nodePosition, nodes[i][j+1].position, nodes[i][j+1].acceleration));
        }
        nodes[i][j].update();
      }
    }
    // }
  }
  PVector applyForce(PVector nodePosition, PVector influence, PVector velocity) {
    PVector difference = PVector.sub(influence, nodePosition);
    float ext = difference.mag()-L;
    PVector result = PVector.fromAngle(difference.heading());
    result.setMag(ext*K);
    return result;
  }
  class Node {
    PVector position, velocity, acceleration, netForce, displacement, orriginalPosition;
    float inverseMass;
    Node(PVector position, float inverseMass) {
      this.position = new PVector(position.x, position.y);
      this.orriginalPosition=new PVector(position.x, position.y);
      displacement=new PVector(0, 0);
      velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
      netForce= new PVector(0, 0);
      this.inverseMass = inverseMass;
    }
    void pushMesh(PVector location, float strength, PVector direction) {
      //if (onscreen(position.x, position.y)) {
      PVector difference = PVector.sub(new PVector(location.x, location.y), position);
      if ((difference.mag()<100)&&(abs(difference.heading()-direction.heading())<15)) {
        if (difference.mag()>10) {
          PVector force = PVector.fromAngle(difference.heading());
          force.rotate(PI);
          float mag = strength/difference.magSq();
          force.setMag(mag);
          netForce.add(force);
          //}
        }
      }
    }
    void update() {
      displacement = PVector.sub(position, orriginalPosition);
      PVector mouseV = new PVector(pmouseX -mouseX, pmouseY - mouseY);
      if (mousePressed) {
        pushMesh(new PVector(mouseX, mouseY), (mouseButton == LEFT)?-300-mouseV.mag()*300:300+mouseV.mag()*300, mouseV);
      }
      acceleration.set(netForce.x, netForce.y);
      acceleration.mult(inverseMass);
      velocity.add(acceleration);
      velocity.mult(0.935);
      position.add(velocity);
    }
  }
}
Grid mesh;
void setup() {
  size(240, 240);
  mesh = new Grid(new PVector(192, 108), 10);
}
void draw() {
  background(0);
  mesh.update();
  mesh.display();
  println(frameRate);
}
void keyPressed(){
  if(key == 'q'){
    exit();
  }
}
