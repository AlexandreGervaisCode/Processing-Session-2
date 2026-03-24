/*
 * Titre: EDM1700 Projet Final: "[PLACEHOLDER]"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions:
 * Description du projet :
 * Notes:
 */

// Les Game States
boolean isPlayerTurn = false;
boolean isInCombat = false;
boolean isOnTitleScreen = true;
boolean isOnHeroSelect = false;
boolean isOnStatsPage = false;

// Permet de slide up des overlays dans le main menu
float overlayScreenY;

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
Inventory bag; // L'inventaire
Shop itemShop; // L'item shop

void setup() {
  size(1000, 750); // ratio 4:3
  frameRate(30);
  pixelDensity(1);
  savefileLoad();
  initializeVariables();
  loadBasicAssets();
  noStroke();
}

void draw() {
  background(128);
  if (isOnTitleScreen) {
    isPlayerTurn = false;
    isInCombat = false;
    drawTitleScreen();
  }
}

// Charge en mémoire tout les PImages de base (Perso, ennemies, arrière-plans)
void loadBasicAssets() {
  // Load all PImages here
}

// Initialize les variables dans setup
void initializeVariables() {
  overlayScreenY = height;
}

void mousePressed() {
  if (isOnTitleScreen) {
    if (!isOnStatsPage) {
      isOnHeroSelect = mouseDetection(0, 0, 100, 100);
    }
    if (!isOnHeroSelect) {
      isOnStatsPage = mouseDetection(width-100, height-100, 100, 100);
    }
  }
}

void drawTitleScreen() {
  fill(255);
  rect(0, 0, 200, 200);
  pushMatrix();
  translate(0, overlayScreenY);
  fill(0, 0, 0, 50);
  rect(0, 0, width, height);
  if (isOnHeroSelect) {
    if (overlayScreenY > 0) {
      overlayScreenY -= height/15;
    } else {
      overlayScreenY = 0;
    }
    fill(0, 255, 0);
    circle(width/2, height/2, 100);
  } else if (isOnStatsPage) {
    if (overlayScreenY > 0) {
      overlayScreenY -= height/15;
    } else {
      overlayScreenY = 0;
    }
    fill(0, 0, 255);
    circle(width/2, height/2, 100);
  } else if (overlayScreenY < height) {
    overlayScreenY += height/15;
  } else {
    overlayScreenY = height;
  }
  popMatrix();
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

boolean mouseDetection(float posX, float posY, float w, float h) {
  return (mouseX > posX && mouseX < posX+w && mouseY > posY && mouseY < posY+h);
}

// --------------------
// SAVE FILE
// --------------------
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
