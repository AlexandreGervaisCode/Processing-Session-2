// Initiation des variables
float rngRed = 0f;
float rngGreen = 0f;
float rngBlue = 0f;
int alpha = 15;

// Setup la taille de l'écran, l'arrière-plan noir et rend invisible le curseur. Décommenté fullScreen si vous voulez
void setup() {
  size(1000,750);
  /*fullScreen(2);*/
  background(0);
  noCursor();
}

// Nécessaire d'appeler la fonction pour dessiner live
void draw() {}

// Quand la souris bouge, choisi aléatoirement une des composantes de RGB et choisi une valeur aléatoire pour la couleur
// Crée un cercle à la position de la souris avec la couleur généré
void mouseMoved() {
  // Choisi un nombre aléatoire de 0 à 2
  float colorRandom = random(0,3);
  int rngColor = floor(colorRandom);

  // Les différents cas et quelle couleur est modifiée
  if(rngColor==0){
    rngRed = random(0,256);
    floor(rngRed);
    int(rngRed);
  } else if(rngColor==1){
    rngGreen = random(0,256);
    floor(rngGreen);
    int(rngGreen);
  } else if(rngColor==2){
    rngBlue = random(0,256);
    floor(rngBlue);
    int(rngBlue);
  }

  // Création du cercle
  noStroke();
  fill(rngRed, rngGreen, rngBlue, alpha);
  ellipse(mouseX, mouseY, 100, 100);

  // Des messages de debugs qui ne sont plus utiles
  /*
  println("ColorPicker:", rngColor);
  println("Red:", rngRed);
  println("Green:", rngGreen);
  println("Blue:", rngBlue);
  */
}

// J'ai essayé de faire qu'au click de la souris, l'écran se resetterait, mais je n'ai pas réussi à trouver comment faire...
// Au final, j'ai fait que ça ferme l'appli
void mouseClicked() {
  exit();
}

// Quand la mouse wheel est scrollée, augmente ou diminue l'opacité des nouveaux cercles crées
void mouseWheel(MouseEvent event) {
  // l'event nous permet de récolter la valeur -1 ou 1 dépendemment de la direction du scroll
  float e = event.getCount();
  if(e<0 && alpha>=0 && alpha<255) {
    alpha+=1;
  } else if(e>0 && alpha<=255 && alpha>0) {
    alpha-=1;
  }

  /*
  println("Alpha:", alpha);
  println("MouseWheel:", e);
  */
}
