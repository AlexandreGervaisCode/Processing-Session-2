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

void setup() {
  size(1000,750);
  posX = width/2;
  posY = height/2;
  hitpoints = 20;
}

void draw(){ 
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
    if (key=='w' && posY>(height-BOX_SIZE)/2+20){
      posY-=4;
    }
    if (key=='s' && posY<(height-BOX_SIZE)*1.5+30){
      posY+=4;
    }
    if (key=='a' && posX>(width-BOX_SIZE)/2+20){
      posX-=4;
    }
    if (key=='d' && posX<(width-BOX_SIZE)+80){
      posX+=4;
    }
    println(posX, posY, (width-BOX_SIZE)+80);
  }
  
  // Bounding Box
  rectMode(CENTER);
  noFill();
  strokeWeight(8);
  stroke(COL_BORDER);
  square(width/2,height/2,BOX_SIZE);
}
