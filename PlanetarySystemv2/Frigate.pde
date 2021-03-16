// Fabián Alfonso Beirutti Pérez
// 2021 - CIU

class Frigate {
  float x;
  float y;
  float z;
  float speed;
  
  PShape frigate;
  
  Frigate() {
    this.x = 0;
    this.y = 1500;
    this.z = 9000;
    frigate = loadShape("RepublicFrigate.obj");
  }

  void display(){
    pushMatrix();
    rotateX(radians(rotateX));
    scale(0.1);
    translate(this.x, this.y, this.z);
    rotateX(PI);
    if (!camera) shape(frigate);
    popMatrix();
  }
  
  void updateX(float aux) {
    this.x += aux;
  }
  
  void updateY(float aux) {
    this.y += aux;
  }
  
  void updateZ(float aux) {
    if (aux < 0 && !camera) drawStarfield();
    this.z += aux;
  }
  
  void resetPosition() {
    this.x = 0;
    this.y = 1500;
    this.z = 9000;
  }
}
