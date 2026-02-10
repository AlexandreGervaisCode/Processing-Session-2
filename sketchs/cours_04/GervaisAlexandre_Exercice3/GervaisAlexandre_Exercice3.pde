/*
 * Titre: EDM1700 Exercice 3: "Peinture à numéros"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions: Sélectionnez une des 3 couleurs qui ont chacun un pinceau associé
 *               en cliquant dessus. Cliquez sur la souris pendant que le canevas
 *               est survolé pour peinturer. Appuyez sur espace pour effacer.
 * Description du projet: Un canevas et des pinceaux pour peinturer.
 */
 
// Initiation des variables globales --------------------
// Couleurs de pinceaux
final color COL_RED = color(250,96,96);
final color COL_PINK = color(203,12,159);
final color COL_PURPLE = color(177,59,201);
// Variables liées à l'interface
final color COL_OVERLAY = color(126,99,56);
final color COL_CANVAS = color(20);
final color COL_SELECT_STROKE = color(255);
final int SELECT_STROKE_WIDTH = 4;
final float UI_WIDTH = 100;        // Largeur de la barre d'outils
final float UI_SELECT_Y = 150;     // Position Y des sélections
final float UI_SELECT_WIDTH = 80; // Largeur des sélections
// Couleurs de survol dans la barre d'outils
final color COL_SELECT_HOVER_RED = lerpColor(COL_RED,COL_CANVAS,0.2);
final color COL_SELECT_HOVER_PINK = lerpColor(COL_PINK,COL_CANVAS,0.2);
final color COL_SELECT_HOVER_PURPLE = lerpColor(COL_PURPLE,COL_CANVAS,0.2);
// Sélection de couleurs
int brushIndex = 0;  // Détermine le pinceau sélectionné

// Propriété de base --------------------
void setup() {
  size(800,600);
  background(COL_CANVAS);
}

void draw() {
  noStroke();
  float mouseDiffX = abs(mouseX-pmouseX);
  float mouseDiffY = abs(mouseY-pmouseY);
  // Dessiner sur le canevas --------------------
  if(mousePressed && mouseX>UI_WIDTH){
    if (brushIndex == 0) {
      // Pinceau Rouge ("Crosshair" de jeu vidéo)
      fill(COL_RED);
      for (float i=0; i<360; i+=90) {
        pushMatrix();
        translate(mouseX,mouseY);
        rotate(radians(i));
        rect(mouseDiffX/6*-1,mouseDiffX,mouseDiffX/3,mouseDiffX);
        popMatrix();
      }
      circle(mouseX,mouseY,mouseDiffX);
    } else if (brushIndex == 1) {
      // Pinceau Rose (Brush Strokes)
      stroke(COL_PINK);
      strokeWeight(mouseDiffX);
      line(pmouseX,pmouseY,mouseX,mouseY);
      noStroke();
    } else if (brushIndex == 2) {
      // Pinceau Violet (Carré)
      fill(COL_PURPLE);
      shapeMode(CENTER);
      square(mouseX,mouseY,mouseDiffY);
      shapeMode(CORNER);
    } else {
      // Au cas où l'index du pinceau est SOMEHOW hors de la range.
      println("BRUSH INDEX ERROR");
    }
  }
  // Réinitialise le canevas quand la barre d'espace est appuyée --------------------
  if (keyPressed && key == ' '){
    background(COL_CANVAS);
  }
  
  // Interface de sélection de couleurs --------------------
  fill(COL_OVERLAY);
  rect(0,0,UI_WIDTH,height);
  stroke(COL_SELECT_STROKE);
  strokeWeight(SELECT_STROKE_WIDTH);
  
  // Détection de survolement
  float distanceBrushRed = dist(mouseX,mouseY,UI_WIDTH/2,UI_SELECT_Y);
  float distanceBrushPink = dist(mouseX,mouseY,UI_WIDTH/2,UI_SELECT_Y*2);
  float distanceBrushPurple = dist(mouseX,mouseY,UI_WIDTH/2,UI_SELECT_Y*3);
  // Cercle UI Rouge
  if (distanceBrushRed<=UI_SELECT_WIDTH/2) { // Si survolé
    fill(COL_SELECT_HOVER_RED);
  } else { // Si non-survolé
    fill(COL_RED);
  }
  circle(UI_WIDTH/2,UI_SELECT_Y,UI_SELECT_WIDTH);
  // Cercle UI Rose
  if (distanceBrushPink<=UI_SELECT_WIDTH/2) { // Si survolé
    fill(COL_SELECT_HOVER_PINK);
  } else { // Si non-survolé
    fill(COL_PINK);
  }
  circle(UI_WIDTH/2,UI_SELECT_Y*2,UI_SELECT_WIDTH);
  // Cercle UI Violet
  if (distanceBrushPurple<=UI_SELECT_WIDTH/2) { // Si survolé
    fill(COL_SELECT_HOVER_PURPLE);
  } else { // Si non-survolé
    fill(COL_PURPLE);
  }
  circle(UI_WIDTH/2,UI_SELECT_Y*3,UI_SELECT_WIDTH);
  
  // Attribution de couleur
  if (distanceBrushRed<=UI_SELECT_WIDTH/2 && mousePressed) {
    brushIndex=0;
  } else if (distanceBrushPink<=UI_SELECT_WIDTH/2 && mousePressed) {
    brushIndex=1;
  } else if (distanceBrushPurple<=UI_SELECT_WIDTH/2 && mousePressed) {
    brushIndex=2;
  }
}
