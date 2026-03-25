/*
 * Titre: EDM1700 Projet Final: "[PLACEHOLDER]"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions:
 * Description du projet :
 * Notes:
 */

// import processing.sound.*;

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

// Les variables de Title Screen
PImage titleBG;
PImage titleLogo;
float logoPosX;
float logoPosY;
float logoWidth;
float logoHeight;
// Width et Height de tout les boutons dans le main menu
float startMenuButtonX;
float startMenuButtonWidth;
float startMenuButtonHeight;
float heroSelectButtonY; // position Y du bouton Select Hero
float statsPageButtonY; // position Y du bouton Stats
float quitAppButtonY; // position Y du bouton quitter app
float startMenuTextOffset;

// PImage selectHeroPoster; // Do one for each Hero

// Variables de classes
Player hero; // Le joueur
Enemy[] mobs = new Enemy[5]; // Jusqu'à 5 ennemies peuvent être à l'écran à la fois
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
  // Initialize les position des boutons dans l'écran titre
  startMenuButtonX = width/10;
  startMenuButtonWidth = width/3;
  startMenuButtonHeight = height/12;
  heroSelectButtonY = height/8*4;
  statsPageButtonY = height/8*5;
  quitAppButtonY = height/8*6;
  startMenuTextOffset = startMenuButtonX+(startMenuButtonWidth/2);
  logoPosX = width/12;
  logoPosY = height/12;
  logoWidth = 500;
  logoHeight = 150;
}

void mousePressed() {
  if (isOnTitleScreen) {
    // Affiche l'écran de personnages
    if (!isOnStatsPage) {
      isOnHeroSelect = mouseDetection(startMenuButtonX, heroSelectButtonY, startMenuButtonWidth, startMenuButtonHeight);
    }
    // Affiche l'écran des stats
    if (!isOnHeroSelect) {
      isOnStatsPage = mouseDetection(startMenuButtonX, statsPageButtonY, startMenuButtonWidth, startMenuButtonHeight);
    }
    // Ferme l'application
    if (!isOnHeroSelect && !isOnStatsPage && mouseDetection(startMenuButtonX, quitAppButtonY, startMenuButtonWidth, startMenuButtonHeight)) {
      exit();
    }
  }
}

void drawTitleScreen() {
  fill(255);
  rect(logoPosX, logoPosY, logoWidth, logoHeight);
  textSize(24);
  textAlign(CENTER);
  // Dessine les boutons
  rect(startMenuButtonX, heroSelectButtonY, startMenuButtonWidth, startMenuButtonHeight);
  rect(startMenuButtonX, statsPageButtonY, startMenuButtonWidth, startMenuButtonHeight);
  rect(startMenuButtonX, quitAppButtonY, startMenuButtonWidth, startMenuButtonHeight);
  // Écrit le texte dans les boutons
  fill(0);
  text("Start Game", startMenuTextOffset, heroSelectButtonY+(startMenuButtonHeight/2));
  text("Stats", startMenuTextOffset, statsPageButtonY+(startMenuButtonHeight/2));
  text("Quit", startMenuTextOffset, quitAppButtonY+(startMenuButtonHeight/2));
  // Écran qui pop up
  pushMatrix();
  translate(0, overlayScreenY);
  fill(0, 0, 0, 50);
  rect(0, 0, width, height);
  fill(0);
  if (isOnHeroSelect) {
    drawHeroSelect();
  } else if (isOnStatsPage) {
    statsPage();
  } else if (overlayScreenY < height) {
    overlayScreenY += height/15;
  } else {
    overlayScreenY = height;
  }
  popMatrix();
}

void statsPage() {
  if (overlayScreenY > 0) {
      overlayScreenY -= height/15;
    } else {
      overlayScreenY = 0;
    }
    fill(0);
    textSize(30);
    textAlign(LEFT);
    text("Enemies defeated: "+savefile.getInt("mobSlain")+"\nRuns attempts: "+savefile.getInt("runNbr")+"\nSuccessful runs: "+savefile.getInt("winNbr")+"\nDefeats: "+savefile.getInt("defeatNbr"), width/4, height/10);
}

void drawHeroSelect() {
  // image(heroSelectBG, 0, 0, width, height);
  // for loop to draw all character portraits and names
  if (overlayScreenY > 0) {
      overlayScreenY -= height/15;
    } else {
      overlayScreenY = 0;
    }
    fill(0, 0, 255);
    circle(width/2, height/2, 100);
}

// Timer
float timer(float countdown) {
  if (countdown > 0) {
    countdown-=1/frameRate;
  }
  return countdown;
}

// Fonction pour plus facilement et rapidement checker si la souris survol un objet
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
