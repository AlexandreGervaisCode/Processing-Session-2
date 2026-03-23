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
JSONObject savefile;
JSONArray unlockedItems;

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
  savefileLoad();
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

// Charge en mémoire tout les PImages de base (Perso, ennemies, arrière-plans)
void loadBasicAssets() {
  // Load all PImages here
}

// Initialize les variables dans setup
void initializeVariables() {
  isOnTitleScreen = true;
}

void drawTitleScreen() {
  fill(0);
  rect(0, 0, 200, 200);
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

void savefileLoad() {
  // Load le fichier de sauvegarde
  savefile = loadJSONObject("json/savefile.json");
  if (savefile == null) { // Crée le fichier de sauvegarde
    savefile = new JSONObject();
    // Met les tout les persos au niveau 1, 0 exp. Perso 3, 4 et 5 sont locked
    savefile.setInt("char0_exp", 0);
    savefile.setInt("char0_lvl", 1);

    savefile.setInt("char1_exp", 0);
    savefile.setInt("char1_lvl", 1);

    savefile.setInt("char2_exp", 0);
    savefile.setInt("char2_lvl", 1);

    savefile.setInt("char3_exp", 0);
    savefile.setInt("char3_lvl", 1);
    savefile.setBoolean("char3_unlocked", false);

    savefile.setInt("char4_exp", 0);
    savefile.setInt("char4_lvl", 1);
    savefile.setBoolean("char4_unlocked", false);

    savefile.setInt("char5_exp", 0);
    savefile.setInt("char5_lvl", 1);
    savefile.setBoolean("char5_unlocked", false);

    // Stats visibles sur la stats page
    savefile.setBoolean("hasWon", false);
    savefile.setInt("mobSlain", 0);
    savefile.setInt("defeatNbr", 0);
    savefile.setInt("runNbr", 0);
    savefile.setInt("winNbr", 0);
    
    unlockedItems = new JSONArray();
    savefile.setJSONArray("unlockedItems", unlockedItems);

    saveJSONObject(savefile, "data/json/savefile.json");
  } else {
    unlockedItems = savefile.getJSONArray("unlockedItems");
  }
}

void saveGame() { // Sauvegarde le progrès
  saveJSONObject(savefile, "data/json/savefile.json");
}
