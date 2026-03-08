/*
 * Titre: EDM1700 Exercice 5: "Oiseaux de nuit"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions: Survolé un oiseau pour obtenir son état (réveillé/endormi)
 * Description du projet : Des oiseaux sont présents et avec le survol, l'oiseau
   connecté à la souris change d'état.
 * Notes: J'avais essayé de faire que la width et height des hiboux sont aléatoires,
          mais c'était bordellique car ils changeaient à chaque frame. Ça aurait
          été cool...
 */

// Variables pour les hiboux en arrière-plan
color rngCol = color(random(255), random(255), random(255));
float openEyeWidth = 30;
float openEyeHeight = 60;
float closeEyeWidth = 60;
float closeEyeHeight = 40;

// Variables pour l'hiboux à la souris
boolean isEyesOpened = true;
final color COL_MOUSE_BODY = color(70);

// Coleurs des l'hiboux
final color COL_FACE = color(255);
final color COL_EYES = color(0);

// Belle fenêtre carré de 600px par 600px
void setup() {
  size(600,600);
}

void draw(){
  // Arrière-plan gris
  background(128);
  // Sert pour faire le pattern yeux ouvert/yeux fermés des hiboux
  boolean stateSelected = true;
  // Fait une grid d'hiboux qui change entre yeux ouvert et fermés
  for (float x = width/6; x < width; x += width/6) {
    for (float y = height/6; y < height; y += height/6) {
      // Change l'état des yeux
      stateSelected=!stateSelected;
      // Variation des tailles dépendemment des yeux
      if (stateSelected) {
        drawBird(x, y, openEyeWidth, openEyeHeight, stateSelected, rngCol, false);
      } else {
        drawBird(x, y, closeEyeWidth, closeEyeHeight, stateSelected, rngCol, false);
      }
    }
  }
  // L'hiboux lié à la souris
  drawBird(mouseX, mouseY, 50, 70, isEyesOpened, COL_MOUSE_BODY, true);
}

// Fonction principale, dessine tout
void drawBird(float birdX, float birdY, float birdWidth, float birdHeight, boolean birdEyes, color birdColor, boolean isMouseBird){
  noStroke();
  // Détecte la collision entre hiboux et souris
  if (birdX <= mouseX && mouseX <= (birdX + birdWidth) && (birdY-birdHeight) <= mouseY && mouseY <= (birdY+birdHeight) && !isMouseBird) {
    isEyesOpened = birdEyes;
  }
  // Dessine les parties du corps
  drawBody(birdX, birdY, birdWidth, birdHeight/2, birdColor);
  drawChin(birdX, birdY-(birdHeight/3), birdWidth/2, birdHeight/2);
  drawEyes(birdX, birdY-(birdHeight/3), birdWidth, birdHeight/8, birdEyes);
  drawBeak(birdX, birdY-(birdHeight/8), birdWidth, birdHeight);
}

// Corps de l'hiboux
void drawBody(float bodyX, float bodyY, float bodyWidth, float bodyHeight, color bodyCol){
  stroke(bodyCol); // Met le corps d'une couleur aléatoire ou gris foncé
  strokeWeight(bodyWidth);
  line(bodyX, bodyY+bodyHeight, bodyX, bodyY-bodyHeight); // Corps
  noStroke();
}

// Menton de l'hiboux
void drawChin(float chinX, float chinY, float chinWidth, float chinHeight){
  noStroke();
  fill(COL_FACE); // Met la face blanche
  ellipse(chinX-chinWidth/2, chinY-(chinHeight/10), chinWidth, chinHeight); // Dome oeil gauche
  ellipse(chinX+chinWidth/2, chinY-(chinHeight/10), chinWidth, chinHeight); // Dome oeil droit
  arc(chinX, chinY, chinWidth*2, chinHeight*2, 0, PI); // Menton
}

// Yeux de l'hiboux
void drawEyes(float eyeX, float eyeY, float eyeWidth, float eyeHeight, boolean isEyesOpen){
  noStroke();
  fill(COL_EYES);
  if (isEyesOpen) { // Si les yeux sont ouverts
    ellipse(eyeX-(eyeWidth/8), eyeY, eyeWidth/8, eyeHeight); // Oeil gauche
    ellipse(eyeX+(eyeWidth/8), eyeY, eyeWidth/8, eyeHeight); // Oeil droit
  } else { // Si les yeux sont fermés
    stroke(COL_EYES);
    strokeWeight(eyeWidth/8);
    line(eyeX-(eyeWidth/3), eyeY, eyeX-(eyeWidth/5), eyeY); // Oeil gauche
    line(eyeX+(eyeWidth/3), eyeY, eyeX+(eyeWidth/5), eyeY); // Oeil droit
    noStroke();
  }
  
}

// Bec de l'hiboux
void drawBeak(float beakX, float beakY, float beakWidth, float beakHeight){
  noStroke();
  fill(COL_EYES); // Met le bec noir
  quad(beakX, beakY-(beakHeight/10), beakX+(beakWidth/10), beakY, beakX, beakY+(beakHeight/10), beakX-(beakWidth/10), beakY); // Bec
}
