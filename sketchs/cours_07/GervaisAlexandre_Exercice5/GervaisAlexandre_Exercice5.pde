/*
 * Titre: EDM1700 Exercice 5: "Oiseaux de nuit"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions: Survolé un oiseau pour obtenir son état (réveillé/endormi)
 * Description du projet : Des oiseaux sont présents et avec le survol, l'oiseau
   connecté à la souris change d'état.
 * Notes: 
 */

final color COL_BODY = color(70);
final color COL_FACE = color(255);
final color COL_EYES = color(0);
boolean isEyesOpened = true;

void setup() {
  size(800,600);
  background(128);
}

void draw(){
  /*
  pushMatrix();
  translate(width/2, height/2);
  popMatrix();
  */
  drawBird(width/2, height/2, 50, 70, isEyesOpened);
  drawBird(30, 30, 50, 30, true);
  drawBird(700, 500, 80, 80, false);
}

void drawBird(float birdX, float birdY, float birdWidth, float birdHeight, boolean isEyesOpen){
  noStroke();
  drawBody(birdX, birdY, birdWidth, birdHeight/2);
  drawChin(birdX, birdY-(birdHeight/3), birdWidth/2, birdHeight/2);
  drawEyes(birdX, birdY-(birdHeight/3), birdWidth, birdHeight/8, isEyesOpen);
  drawBeak(birdX, birdY-(birdHeight/8), birdWidth, birdHeight);
}

void drawBody(float bodyX, float bodyY, float bodyWidth, float bodyHeight){
  stroke(COL_BODY);
  strokeWeight(bodyWidth);
  line(bodyX, bodyY+bodyHeight, bodyX, bodyY-bodyHeight); // body
  noStroke();
}

void drawChin(float chinX, float chinY, float chinWidth, float chinHeight){
  noStroke();
  fill(COL_FACE);
  ellipse(chinX-chinWidth/2, chinY-(chinHeight/10), chinWidth, chinHeight); // left eye dome
  ellipse(chinX+chinWidth/2, chinY-(chinHeight/10), chinWidth, chinHeight); // right eye dome
  arc(chinX, chinY, chinWidth*2, chinHeight*2, 0, PI); // chin
}

void drawEyes(float eyeX, float eyeY, float eyeWidth, float eyeHeight, boolean isEyesOpen){
  noStroke();
  fill(COL_EYES);
  if (isEyesOpen) {
    ellipse(eyeX-(eyeWidth/8), eyeY, eyeWidth/8, eyeHeight); // left eye
    ellipse(eyeX+(eyeWidth/8), eyeY, eyeWidth/8, eyeHeight); // right eye
  } else {
    stroke(COL_EYES);
    strokeWeight(eyeWidth/8);
    line(eyeX-(eyeWidth/3), eyeY, eyeX-(eyeWidth/5), eyeY);
    line(eyeX+(eyeWidth/3), eyeY, eyeX+(eyeWidth/5), eyeY);
    noStroke();
  }
  
}

void drawBeak(float beakX, float beakY, float beakWidth, float beakHeight){
  noStroke();
  fill(COL_EYES);
  quad(beakX, beakY-(beakHeight/10), beakX+(beakWidth/10), beakY, beakX, beakY+(beakHeight/10), beakX-(beakWidth/10), beakY); // beak
}
