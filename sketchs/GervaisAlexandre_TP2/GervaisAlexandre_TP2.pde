/*
 * Titre: EDM1700 Projet Final: "[PLACEHOLDER]"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions: 
 * Description du projet : 
 * Notes: 
 */

// Les Game States
boolean isPlayerTurn;
boolean isInCombat;
boolean isOnTitleScreen;
boolean isOnHeroSelect;

// Si l'utilisateur a déjà joué
boolean hasSaveFile;
JSONObject savefile;

// Les assets de Title Screen
PImage titleBG;
PImage titleLogo;
// PImage selectHeroPoster; // Do one for each Hero

// Variables de classes
Player hero; // Le joueur
Enemy mob1; // Jusqu'à 5 ennemies peuvent être à l'écran à la fois
Enemy mob2;
Enemy mob3;
Enemy mob4;
Enemy mob5;

void setup() {
  size(900, 700);
  frameRate(30);
  try {
    savefile = loadJSONObject("savefile.json");
    hasSaveFile = true;
  } catch (NullPointerException e) {
    hasSaveFile = false;
  }
  initializeVariables();
  loadBasicAssets();
}

void draw() {
  background(128);
  if (isOnTitleScreen) {
    isPlayerTurn = false;
    isInCombat = false;
    if (!isOnHeroSelect) {
      drawTitleScreen();
    } else {
      drawHeroSelect();
    }
  }
}

// Charge en mémoire tout les PImages de base
void loadBasicAssets() {
  // Load all PImages here
}

// Initialize les variables dans setup
void initializeVariables() {
  isOnTitleScreen = true;
}

void drawTitleScreen() {
  fill(0);
  rect(0,0,200,200);
}

void drawHeroSelect() {
  // image(heroSelectBG, 0, 0, width, height);
  // for loop to draw all character portraits and names
}

// Timer
float timer(float countdown) {
  if (countdown > 0) {
    countdown-=1/frameRate;
  }
  return countdown;
}
