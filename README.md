# PlanetarySystem v2 by Fabián Alfonso Beirutti Pérez
Planetary system including a camera/spaceship functionality using processing.

## Introducción
El objetivo de esta segunda práctica de la asignatura de 4to, Creación de Interfaces de Usuario (CIU), es empezar a tratar los conceptos y las primitivas básicas 3D para el dibujo de objetos. Para ello, se ha pedido el desarrollo de una aplicación que simule un sistema planetario en movimiento y que incluya, una nave que se desplace en el sistema y una funcionalidad de una cámara que nos permita cambiar la perspectiva desde la que se ve el proyecto. Todo ello, usando el lenguaje de programación y el IDE llamado Processing. Este permite desarrollar código en diferentes lenguajes y/o modos, como puede ser processing (basado en Java), p5.js (librería de JavaScript), Python, entre otros.
<p align="center"><img src="/planetarySystem2Gif.gif" alt="Planetary system v2 using processing"></img></p>

## Controles
Los controles de la aplicación se mostrarán en todo momento por pantalla para facilitar su uso al usuario:
- **Teclas W A S D:** Desplaza la nave respecto a los ejes vertical y horizontal (sube/baja, izquierda/derecha).
- **Teclas Q E:** Desplaza la nave respecto al eje Z (se acerca/aleja al sistema).
- **Tecla C:** Cambia la perspectiva.
- **Teclas N M:** Al presionar estas teclas podremos rotar nuestro sistema planetario para observar el resultado en su completitud.
- **Tecla ESC:** Cerrar la aplicación.

## Descripción
Aprovechando que el lenguaje de programación que utiliza el IDE Processing por defecto está basado en Java, podemos desarrollar nuestro código utilizando el paradigma de programación de "Programación Orientada a Objetos". Así pues, hemos descrito tres clases de Java:
- **PlanetarySystemv2:** clase principal.
- **Planet:** clase que representa al objeto/resultado de crear cada planeta.
- **Moon:** clase que representa al objeto/resultado de crear cada luna y/o satélite de un planeta.
- **Star:** clase que representa al objeto/resultado de crear una estrella.
- **Dot:** clase que representa al objeto/resultado de crear cada uno de los puntos que conforma el *starfield* o campo de estrellas.
- **Frigate:** clase que representa al objeto/resultado de crear la nave.

Para la realización de este proyecto se ha reutilizado el código de *PlanetarySystem*. Así pues,se han aplicado mejoras funcionales y extras al mismo como, por ejemplo, una pantalla de inicio dinámica o un efecto de campo de estrellas o *starfield* que transmite la sensación al usuario de velocidad, esto es, que se desplaza en el sistema.

## Explicación
### Clase PlanetarySystemv2
Esta es la clase principal de la aplicación, la cual gestiona la información mostrada por pantalla al usuario (interfaz gráfica), esto es, el desarrollo de los métodos setup() y draw().
```java
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
```
Aquí se declaran varios métodos que nos ayudan a mantener el código limpio y ordenado, además de permitir que en un futuro, si se realizan cambios, no afecten a todo el código. Tenemos dos métodos: *initSystem()* y *drawSystem()*, estos, son los encargados de cargar las imágenes/texturas que se le aplicaran a las esferas, inicializar los objetos que conforman el sistema planetario y de llamar a los métodos nativos de las clases de los objetos *Planet*, *Moon* y *Star* que mostrará por pantalla las esferas, su movimiento alrededor de un punto central (en nuestro caso, al representar el Sistema Solar, es el Sol), y comprobará y reseteará el ángulo de giro de los planetas y lunas y/o satélites.

Como se puede ver, para la implementación de la cámara, se ha realizado de una manera diferente a usar la función *camera()* y sus nueve argumentos, esto es porque, no se conseguía el resultado esperado y por ello, se buscó una segunda opción. La solución por la que se ha optado hace uso de funciones propias de Processing, de manera que, todas aquellas funciones/métodos y/o transformaciones que se encuentren entre *beginCamera()* y *endCamera()*, se aplicarán a la configuración por defecto de *camera()*. Así pues, la cámara se desplazará a unas coordenadas en el sistema que corresponden aproximadamente con la misma posición de la nave, simulando así, una vista en primera persona.
```java
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
```
Por otra parte, esta misma clase es la que maneja la interacción entre el usuario y la interfaz mediante la implementación de los métodos keyPressed(), keyReleased(), mousePressed(), entre otros. Un ejemplo se muestra a continuación:
```java
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
```
Como se puede apreciar en el código anterior, cada vez que se presiona y se suelta una de las teclas, W o S, se actualizarán los valores de dos variables booleanas (toman el valor de verdadero o falso) que nos permitirán tener un mejor control sobre las acciones del usuario y su interacción con la interfaz. Así conseguimos que, el desplazamiento de la nave y la rotación de nuestro sistema planetario, sea fluída y que no se noten parpadeos o cambios bruscos en las posiciones de las figuras.

### Clase Planet
Es la clase que representa a un Planeta. Aquí, se modifican y configuran las características y propiedades de cada objeto *Planet*, y donde están implementados los métodos *orbit()* y *display()*. Estos, comprobarán el ángulo de rotación y lo reseteará una vez se haya completado un giro/vuelta, y, muestra por pantalla la esfera, inicia su movimiento y añade su nombre debajo del mismo. 
```java
void orbit(){
  angle += speed;
  if(angle >= 360){
    angle = 0;
  }
  if(moon != null){
    moon.orbit();
  }
}
  
void display(){
  pushMatrix();
  rotateX(radians(rotateX))
  rotateY(radians(angle));
  translate(distance * vector.x, vector.y, vector.z);
  shape(planet);
  textAlign(CENTER);
  textSize(16);
  text(name, 0, radius + 30);
  if(moon != null)
  moon.display();
  }
  popMatrix();
}
```
Como se puede ver, cada objeto *Planet*, lleva asociado o no, otro objeto *Moon*, que en caso de disponer de uno, solo se mostrará por pantalla si existe el planeta al que está vinculado/relacionado, esto es, si un objeto *Planet* al inicializarlo se le indica un objeto *Moon*, el planeta será el encargado de llamar a los métodos *orbit()* y *display()* de la luna y/o satélite.

### Clase Frigate
Es la clase que representa a la nave que recorre el sistema planetario. Aquí, se configuran las características y propiedades del objeto *Frigate*, y donde están implementados los métodos que actualizan la posición de la nave en el sistema, la resetean y la muestran por pantalla, como, por ejemplo, el método *display()*.
```java
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
```
Es la clase que representa a la nave que recorre el sistema planetario. Aquí, se configuran las características y propiedades del objeto *Frigate*, y donde están implementados los métodos que actualizan la posición de la nave en el sistema, la resetean y la muestran por pantalla.

## Descarga y prueba
Para poder probar correctamente el código, es necesario descargar todos los ficheros (el .zip del repositorio) y en la carpeta llamada PlanetarySystemv2 se encuentran los archivos de la aplicación listos para probar y ejecutar. El archivo "README.md" y aquellos fuera de la carpeta del proyecto (PlanetarySystemv2), son opcionales, si se descargan no deberían influir en el funcionamiento del código ya que, son usados para darle formato a la presentación y explicación del repositorio en la plataforma GitHub.

## Recursos empleados
Para la realización de este sistema planetario en 3D, se han consultado y/o utilizado los siguientes recursos:
* Guión de prácticas de la asignatura CIU
* <a href="https://processing.org">Página de oficial de Processing y sus referencias y ayudas</a>
* Processing IDE

Por otro lado, las librerías empleadas fueron:
* <a href="https://github.com/extrapixel/gif-animation">GifAnimation</a>

Modelo 3D de la nave:
* "<a href="https://skfb.ly/6RNL6">Star Wars Republic Frigate</a>" by <a href="https://sketchfab.com/iedalton">iedalton</a> from Sketchfab.
