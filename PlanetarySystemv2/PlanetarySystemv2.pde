// Fabián Alfonso Beirutti Pérez
// 2021 - CIU

Dot[] dots = new Dot[700];
float speed, ang, angS;
PShape menuEarth, menuMoon;

PShape menuFrigate;
boolean camera;
Frigate frigate;
float speedFrigate, camX, camY, camZ;

PImage bgImg, sunImg, mercuryImg, venusImg, earthImg, moonImg, marsImg, jupiterImg, saturnImg, neptuneImg;
Star sun;
Planet mercury, venus, earth, mars, jupiter, saturn, neptune;
Moon moon;

float rotateX;
boolean menu, keyStatus, m, n, up, down, left, right, forward, backward;

void setup() {
  size (1500, 844, P3D);
  initDots();
  speedFrigate = 20;
  menuFrigate = loadShape("RepublicFrigate.obj");
  frigate = new Frigate();
  ang = 0;
  surface.setTitle("Planetary System v2");
  menu = true;
  camera = false;
  bgImg = loadImage("background.jpg");
  rotateX = 0.0;
  initSystem();
}

void draw() {
  if (camera) {
    camX = -frigate.x/10;
    camY = -frigate.y/10;
    camZ = -frigate.z/10;
    beginCamera();
    camera();
    translate(camX, camY+30, camZ+1200);
    endCamera();
    //camera(frigate.x, frigate.y, 2000, frigate.x, height/2, -frigate.z, 0, 1, 0);
  }else{
    camera();
  }
  lights();
  if (menu) menu();
  else {
    background(bgImg);
    if (!camera) showHelp();
    translate(width/2, height/2, -550);
    drawSystem();
    rotateSystem();
    frigateControls();
  }
}

void initSystem() {
  sunImg = loadImage("Sun.jpg");
  mercuryImg = loadImage("Mercury.jpg");
  venusImg = loadImage("Venus.jpg");
  earthImg = loadImage("Earth.jpg");
  moonImg = loadImage("Moon.png");
  marsImg = loadImage("Mars.jpg");
  jupiterImg = loadImage("Jupiter.jpg");
  saturnImg = loadImage("Saturn.jpg");
  neptuneImg = loadImage("Neptune.jpg");
  this.sun = new Star (100, 0, 0, 0.25, new PVector(0, 0, 0), sunImg, "Sun");
  this.moon = new Moon(15, 1.6, 0, 0.02, new PVector(55, 0, 1), moonImg, "Moon");
  this.mercury = new Planet (35, 4, 0,  0.50, new PVector(40, 0, 1), mercuryImg, "Mercury", null);
  this.venus = new Planet (45, 6, 0,  0.45, new PVector(40, 0, 1), venusImg, "Venus", null);
  this.earth = new Planet (55, 10, 0,  0.40, new PVector(40, 0, 1), earthImg, "Earth", moon);
  this.mars = new Planet (35, 13, 0,  0.35, new PVector(40, 0, 1), marsImg, "Mars", null);
  this.jupiter = new Planet (80, 18, 0,  0.30, new PVector(40, 0, 1), jupiterImg, "Jupiter", null);
  this.saturn = new Planet (65, 24, 0,  0.25, new PVector(40, 0, 1), saturnImg, "Saturn", null);
  this.neptune = new Planet (35, 30, 0,  0.20, new PVector(40, 0, 1), neptuneImg, "Neptune", null);
}

void drawSystem() {
  sun.orbit();  sun.display();
  mercury.orbit();  mercury.display();
  venus.orbit();  venus.display();
  earth.orbit();  earth.display();
  mars.orbit();  mars.display();
  jupiter.orbit();  jupiter.display();
  saturn.orbit();  saturn.display();
  neptune.orbit();  neptune.display();
  frigate.display();
}

void rotateSystem() {
  if (n && rotateX >= -45.0) rotateX -= 0.5;
  if (m && rotateX <= 45.0) rotateX += 0.5;
}

void frigateControls() {
    if (up && frigate.y >= -10000) frigate.updateY(-speedFrigate);
    if (down && frigate.y <= 10000) frigate.updateY(speedFrigate);
    if (left && frigate.x >= -10000) frigate.updateX(-speedFrigate);
    if (right && frigate.x <= 10000) frigate.updateX(speedFrigate);
    if (forward && frigate.z >= -10000) frigate.updateZ(-speedFrigate);
    if (backward && frigate.z <= 10000) frigate.updateZ(speedFrigate);
}

// Initial screen
void menu() {
  background(0);
  translate(width/2, height/2);
  drawStarfield();
  textSize(50);
  textAlign(CENTER);
  fill(255);
  text("Planetary System", 0,-250);
  text("3D model", 0,-200);
  textSize(25);
  text("by Fabián B.", 0, -150);
  fill(255, 0, 0);
  text("Now includes a spaceship!", 0, 250);
  fill(255);
  text("Press ENTER to continue", 0, 350);
  drawMenuPlanet();
}

// Display help
void showHelp() {
  textAlign(LEFT);
  text("> Press N and M keys to rotate the planetary system.", 20,50);
  text("> Press R to reset.", 20, 100);
  text("> Press C to change perspective.", 20, 150);
  text("> Press ESC to exit.", 20, 200);
  text(rotateX, 1420, 50);
  text("Frigate controls:", 20, 650);
  text("> Press W - S to move ↑ ↓.", 20, 700);
  text("> Press A - D to move ← →.", 20, 750);
  text("> Press Q - E to move forward - backward.", 20,800);
  textAlign(RIGHT);
  text("Frigate position:", 1470, 650);
  text("X: " + frigate.x, 1470, 700);
  text("Y: " + frigate.y, 1470, 750);
  text("Z: " + frigate.z, 1470, 800);
}

// Starfield initialization
void initDots(){
  for (int i = 0; i < dots.length; i++) {
    dots[i] = new Dot();
  }
}

// Show starfield
void drawStarfield() {
  speed = 5;
  for (int i = 0; i < dots.length; i++) {
    dots[i].update();
    dots[i].show();
  }
}

// Menu Planet
void drawMenuPlanet(){
  noStroke();
  rotateX(radians(-45));
  
  // Tierra
  pushMatrix();
  rotateY(radians(ang));
  menuEarth = createShape(SPHERE, 100);
  menuEarth.setTexture(earthImg);
  shape(menuEarth);
  popMatrix();
  
  // Resetea tras giro completo
  ang=ang+0.10;
  if (ang>360)
    ang=0;
    
  // Nave 
  pushMatrix();
  rotateY(radians(angS));
  translate(-width*0.10,0,0);
  menuMoon = createShape(SPHERE, 30);
  menuMoon.setTexture(moonImg);
  scale(0.09);
  rotateX(PI);
  rotateY(PI);
  shape(menuFrigate);
  popMatrix();
  
  // Resetea tras giro completo
  angS=angS+0.5;
  if (angS>360)
    angS=0;
}

void keyPressed() {
  if (keyCode == ENTER) menu = false;
  if (key == 'C' || key == 'c') camera = !camera;
  if (key == 'R' || key == 'r') {
    frigate.resetPosition();
    rotateX = 0.0;
  }
  
  keyStatus = true;
  if (key == 'N' || key == 'n') n = keyStatus;
  if (key == 'M' || key == 'm') m = keyStatus;
  if (key == 'W' || key == 'w') up = keyStatus;
  if (key == 'S' || key == 's') down = keyStatus;
  if (key == 'A' || key == 'a') left = keyStatus;
  if (key == 'D' || key == 'd') right = keyStatus;
  if (key == 'Q' || key == 'q') forward = keyStatus;
  if (key == 'E' || key == 'e') backward = keyStatus;
}

void keyReleased() {
  keyStatus = false;
  if (key == 'N' || key == 'n') n = keyStatus;
  if (key == 'M' || key == 'm') m = keyStatus;
  if (key == 'W' || key == 'w') up = keyStatus;
  if (key == 'S' || key == 's') down = keyStatus;
  if (key == 'A' || key == 'a') left = keyStatus;
  if (key == 'D' || key == 'd') right = keyStatus;
  if (key == 'Q' || key == 'q') forward = keyStatus;
  if (key == 'E' || key == 'e') backward = keyStatus;
}
