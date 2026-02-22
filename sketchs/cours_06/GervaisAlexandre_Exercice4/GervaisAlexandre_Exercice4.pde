/*
 * Titre: EDM1700 Exercice 4: "Mini-jeu"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions: Suivez la balle avec la souris le plus longtemps que vous pouvez.
 * Description du projet : Essayez d'avoir le plus haut score possible
 * Notes: J'ai utiliser les objets de typographies tel que text() même si je pense
          qu'on les a pas encore vus, c'est juste utilisé pour le leaderboard
 */

// Initiations des constantes --------------------
// Valeurs initiales
final float START_SIZE = 50;
final float START_SPEED = 3;
// Extrêmitées des tailles
final float MIN_SIZE = 10;
final float MAX_SIZE = 100;
// Ratio de modification du cercle
final float LEVEL_UP_ACCELERATION = 0.5;
final float SIZE_UP_RATE = 0.2;
final float SIZE_DOWN_RATE = 0.1;
// Textes pour les scénarios level up et game over
final String LOSE_TEXT = "Défaite !";
final String WIN_TEXT = "Augmentons la vitesse !";
final String INPUT_TEXT = "Appuyez sur 'R' pour procédez";

// Initiation des variables --------------------
// Caractéristiques du cercle
float circleX;
float circleY;
float circleRadius;
float circleSpeedX;
float circleSpeedY;
// Couleurs du cercle
color growColor;
color shrinkColor;
int growRed;
int growBlue;
int shrinkGreen;
int shrinkBlue;
int circleAlpha;
final int RNG_MAX_SHADE = 175;
// Contrôle du jeu
boolean isNewGame = true;
boolean isGameOver = false;
boolean isLevelUp = false;
// Couleurs
color bgColor;
final color MENU_BG = color(10);
final color GAME_BG = color(255);
final color TEXT_COLOR_MENU = color(222, 250, 15);
// Système de score
final color TEXT_COLOR_SCORE = color(0);
int currentScore;
int highScore = 0;
boolean isNewRecord = false;
float scorePos = 20;

// Met les paramètres de base
void setup() {
  size(800,600);
  noStroke();
  textSize(20);
}

void draw() {
  // Réinitialise les paramètres si c'est une nouvelle partie --------------------
  if (isNewGame) {
    // Paramètres du cercle
    circleX = width/2;
    circleY = height/2;
    circleRadius = START_SIZE;
    circleSpeedX = START_SPEED;
    circleSpeedY = START_SPEED;
    // Paramètres du jeu
    isNewGame = false;
    bgColor = GAME_BG;
    currentScore = 0;
    // Ré-aléatoire les hues
    growRed = int(random(RNG_MAX_SHADE));
    growBlue = int(random(RNG_MAX_SHADE));
    shrinkGreen = int(random(RNG_MAX_SHADE));
    shrinkBlue = int(random(RNG_MAX_SHADE));
  }
  background(bgColor);
  
  // Calcule la distance entre la souris et le cercle
  float distanceCircle = dist(mouseX, mouseY, circleX, circleY);
  circleAlpha = int(map(circleRadius, 10, 100, 10, 255));
  growColor = color(growRed, 255, growBlue, circleAlpha);
  shrinkColor = color(255, shrinkGreen, shrinkBlue, circleAlpha);
  
  // Collision avec le cercle --------------------
  if (distanceCircle <= circleRadius && !isGameOver && !isLevelUp) {
    // Augmente la taille du cercle
    circleRadius += SIZE_UP_RATE;
    fill(growColor);
    // Si le cercle est assez grand, active le scénario Level Up
    if (circleRadius >= MAX_SIZE) {
      isLevelUp = true;
    }
  } else if (!isGameOver && !isLevelUp) {
    // Aucune collision avec le cercle --------------------
    fill(shrinkColor);
    // Réduit la taille du cercle
    circleRadius -= SIZE_DOWN_RATE;
    // Si le cercle est trop petit, active le scénario Game Over
    if (circleRadius <= MIN_SIZE) {
      isGameOver = true;
    }
  }
  
  // Change la direction du cercle si une extrêmitées est atteinte --------------------
  if (circleX + circleRadius + SIZE_UP_RATE >= width ||
      circleX - circleRadius - SIZE_UP_RATE <= 0) {
    circleSpeedX *= -1;
    // Empêche le cercle d'être coincé sur les coins horizontaux
    circleX = constrain(circleX, circleRadius + SIZE_UP_RATE, width - circleRadius - SIZE_UP_RATE);
  }
  if (circleY + circleRadius + SIZE_UP_RATE >= height || 
      circleY - circleRadius - SIZE_UP_RATE <= 0) {
    circleSpeedY *= -1;
    // Empêche le cercle d'être coincé sur les coins verticaux
    circleY = constrain(circleY, circleRadius + SIZE_UP_RATE, height - circleRadius - SIZE_UP_RATE);
  }
  
  // Bouge le cercle si aucun menu est ouvert
  if (!isGameOver && !isLevelUp) {
    circleX += circleSpeedX;
    circleY += circleSpeedY;
    circle(circleX, circleY, circleRadius*2);
  }
  
  // Changement de scénario --------------------
  // Code en commun entre les scénarios
  if (isGameOver || isLevelUp) {
    bgColor = MENU_BG;
    textAlign(CENTER);
    fill(TEXT_COLOR_MENU);
    text(INPUT_TEXT, width/2, height/3*2);
  } else { // Le scoreboard si en jeu
    textAlign(LEFT);
    fill(TEXT_COLOR_SCORE);
    text("Pointage: " + str(currentScore), scorePos, scorePos);
  }
  // Si le cercle devient trop petit
  if (isGameOver) {
    text(LOSE_TEXT, width/2, height/3);
    if (keyPressed && key=='r' || key=='R') {
      isNewGame=true;
      isGameOver = !isGameOver;
    }
  }
  // Si le cercle devient assez grand
  if (isLevelUp) {
    // Affiche le text de victoire
    text(WIN_TEXT, width/2, height/3);
    // Si c'est un nouveau record, met le à jour
    if (currentScore + 1 > highScore) {
      highScore = currentScore+1;
      isNewRecord = true; // Ceci est nécessaire pour garder le bon texte
    }
    
    // Affiche le text approprié si c'est un nouveu record ou non
    if (isNewRecord) {
      text("NOUVEAU RECORD: "+str(highScore)+" !!!", width/2, height/4);
    } else {
      text("Record: "+str(highScore), width/2, height/4); 
    }
    // Si le bouton 'continuer' est appuyé
    if (keyPressed && key=='r' || key=='R') {
      // Augmenter la vitesse X dépendemment de son orientation
      if (circleSpeedX > 0) {
        circleSpeedX += LEVEL_UP_ACCELERATION; 
      } else {
        circleSpeedX -= LEVEL_UP_ACCELERATION;
      }
      // Augmenter la vitesse Y dépendemment de son orientation
      if (circleSpeedY > 0) {
        circleSpeedY += LEVEL_UP_ACCELERATION; 
      } else {
        circleSpeedY -= LEVEL_UP_ACCELERATION;
      }
      // Réinitialise des paramètres clés
      circleX = width/2;
      circleY = height/2;
      circleRadius = START_SIZE;
      isNewRecord = false;
      bgColor = GAME_BG;
      isLevelUp = !isLevelUp;
      currentScore++;
      
      // Ré-aléatoire les hues
      growRed = int(random(RNG_MAX_SHADE));
      growBlue = int(random(RNG_MAX_SHADE));
      shrinkGreen = int(random(RNG_MAX_SHADE));
      shrinkBlue = int(random(RNG_MAX_SHADE));
    }
  }
}
