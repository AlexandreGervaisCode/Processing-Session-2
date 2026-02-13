/*
 * Titre: Projet personel: "Undertale Bullet Hell"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions: Esquiver les attaques avec WASD. Surviver.
 * Description du projet: WO O O O O, STORY OF UNDERTALE
 */

// Color Variables
final color COL_BG = color(0);
final color COL_SOUL = color(255,0,0);
final color COL_BORDER = color(0,192,0);
final color COL_BULLET = color(255);
final color COL_MENU = color(255,127,39);

// Values variables
final float BOX_SIZE = 400;
int hitpoints;
float posX;
float posY;
boolean dUp = false;
boolean dDown = false;
boolean dLeft = false;
boolean dRight = false;
float soulSpeed = 4;

void setup() {
  size(1000,750);
  posX = width/2;
  posY = height/2;
  hitpoints = 20;
}

void draw() { 
  background(COL_BG);
  
  // Soul
  noStroke();
  fill(COL_SOUL);
  pushMatrix();
  translate(posX,posY);
  circle(-7,-5,20);
  circle(7,-5,20);
  popMatrix();
  pushMatrix();
  translate(posX,posY+5);
  rectMode(CENTER);
  rotate(radians(45));
  square(0,0, 15);
  popMatrix();
  
  if (keyPressed) {
    if ((dUp && dLeft) || (dUp&&dRight) || (dDown&&dLeft) || (dDown&&dRight)) {
      soulSpeed = 4/sqrt(2);
    } else {
      soulSpeed = 4;
    }
    if (dUp  && posY>(height-BOX_SIZE)/2+20) {
      posY-=soulSpeed;
    }
    if (dDown && posY<(height-BOX_SIZE)*1.5+30) {
      posY+=soulSpeed;
    }
    if (dLeft && posX>(width-BOX_SIZE)/2+20) {
      posX-=soulSpeed;
    }
    if (dRight && posX<(width-BOX_SIZE)+80) {
      posX+=soulSpeed;
    }
  }
  // Bounding Box
  rectMode(CENTER);
  noFill();
  strokeWeight(8);
  stroke(COL_BORDER);
  square(width/2,height/2,BOX_SIZE);
}

void keyPressed() {
  if (key=='w' || key=='W'){
      dUp=true;
  }
  if (key=='s' || key=='S'){
      dDown=true;
  }
  if (key=='a' || key=='A'){
    dLeft=true;
  }
  if (key=='d' || key=='D'){
    dRight=true;
  }
}

void keyReleased() {
  if (key=='w' || key=='W'){
      dUp=false;
  }
  if (key=='s' || key=='S'){
    dDown=false;
  }
  if (key=='a' || key=='A'){
    dLeft=false;
  }
  if (key=='d' || key=='D'){
    dRight=false;
  }
}
