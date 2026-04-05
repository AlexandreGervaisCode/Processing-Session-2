/*
 * Titre: EDM1700 Projet Final: "Crumbling Thalasso"
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
boolean isInShop = false;
boolean isOnTitleScreen = true;
boolean isOnHeroSelect = false;
boolean isOnStatsPage = false;

// Permet de slide up des overlays dans le main menu
float overlayScreenY;

// Si l'utilisateur a déjà joué
JSONObject savefile;
JSONArray unlockedItems;

// Les Fichiers JSON
JSONArray allHeroes;
JSONArray allMobs;
JSONArray allItems;

// Les variables de Title Screen
PImage titleBG;
PImage titleStartButton;
PImage titleOtherButton;
int darkenBgProgress = 1;
final color COL_DARK = color(36);
final color COL_BLACK = color(0, 0, 0);
final color COL_EXIT_BTN = color(255, 38, 38);
float exitBtnX; // Emplacement des boutons Quitter
float exitBtnY;
float exitBtnW;
float exitBtnH;

// Écran Choisi ton Héro
PImage heroBanner0, heroBanner1, heroBanner2, heroBanner3, heroBanner4, heroBanner5;
PImage[] heroBanners = new PImage[6];
float heroSelectX = 200;
float heroSelectW = 188;
float heroSelectH = 225;
float heroSelectXOffset = 6;

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
  titleBG = loadImage("menus/menu_title_background.png");
  titleStartButton = loadImage("menus/menu_title_startButton.png");
  titleOtherButton = loadImage("menus/menu_title_otherButton.png");
  heroBanner0 = loadImage("menus/character_banner_jack.png");
  heroBanner1 = loadImage("menus/character_banner_jack.png");
  heroBanner2 = loadImage("menus/character_banner_jack.png");
  heroBanner3 = loadImage("menus/character_banner_profit.png");
  heroBanner4 = loadImage("menus/character_banner_jack.png");
  heroBanner5 = loadImage("menus/character_banner_necromancer.png");
  heroBanners[0] = heroBanner0;
  heroBanners[1] = heroBanner1;
  heroBanners[2] = heroBanner2;
  heroBanners[3] = heroBanner3;
  heroBanners[4] = heroBanner4;
  heroBanners[5] = heroBanner5;
}

// Initialize les variables dans setup
void initializeVariables() {
  overlayScreenY = height;
  // Initialize les position des boutons dans l'écran titre
  startMenuButtonX = width/20;
  startMenuButtonWidth = width/10*3;
  startMenuButtonHeight = height/10;
  heroSelectButtonY = height/8*3.5;
  statsPageButtonY = height/8*5;
  quitAppButtonY = height/8*6.5;
  startMenuTextOffset = startMenuButtonX+(startMenuButtonWidth/2);
  
  // Bouton Quitter (utilisé à plusieurs places
  exitBtnX = width/5;
  exitBtnY = height*0.8;
  exitBtnW = width*0.6;
  exitBtnH = height/15;
  
  // Load les JSONs
  allHeroes = loadJSONArray("./json/heroes.json");
  allMobs = loadJSONArray("./json/enemies.json");
  allItems = loadJSONArray("./json/items.json");
}

void mousePressed() {
  if (isOnTitleScreen) {
    // Affiche l'écran de personnages ou stats
    if (!isOnStatsPage && !isOnHeroSelect) {
      isOnHeroSelect = mouseDetection(startMenuButtonX, heroSelectButtonY, startMenuButtonWidth, startMenuButtonHeight);
      isOnStatsPage = mouseDetection(startMenuButtonX, statsPageButtonY, startMenuButtonWidth, startMenuButtonHeight);
    }

    // Ferme l'application
    if (!isOnHeroSelect && !isOnStatsPage && mouseDetection(startMenuButtonX, quitAppButtonY, startMenuButtonWidth, startMenuButtonHeight)) {
      exit();
    }
  }
  // Check pour si le bouton Exit a été appuyé dans les écrans appropriés
  if ((isOnStatsPage || isOnHeroSelect || isInShop) && mouseDetection(exitBtnX, exitBtnY, exitBtnW, exitBtnH)) {
    isOnStatsPage = false;
    isOnHeroSelect = false;
    isInShop = false;
  }
}

void drawTitleScreen() {
  // Dessine l'arrière-plan
  image(titleBG, 0, 0, width, height);
  // Dessine les boutons
  image(titleStartButton, startMenuButtonX, heroSelectButtonY, startMenuButtonWidth, startMenuButtonHeight);
  image(titleOtherButton, startMenuButtonX, statsPageButtonY, startMenuButtonWidth, startMenuButtonHeight);
  image(titleOtherButton, startMenuButtonX, quitAppButtonY, startMenuButtonWidth, startMenuButtonHeight);
  // Écrit le texte dans les boutons
  fill(255);
  textSize(24);
  textAlign(CENTER);
  text("Start Game", startMenuTextOffset, heroSelectButtonY+(startMenuButtonHeight/2));
  text("Stats", startMenuTextOffset, statsPageButtonY+(startMenuButtonHeight/2));
  text("Quit", startMenuTextOffset, quitAppButtonY+(startMenuButtonHeight/2));
  // Écran qui pop up
  fill(COL_BLACK, darkenBgProgress);
  rect(0, 0, width, height);
  pushMatrix();
  translate(0, overlayScreenY);
  fill(0);
  if (isOnHeroSelect) {
    drawHeroSelect();
  } else if (isOnStatsPage) {
    statsPage();
  } else if (overlayScreenY < height) {
    println("this if");
    overlayScreenY += height/15;
    darkenBgProgress -= ceil(70/15);
  } else {
    println("the else");
    overlayScreenY = height;
    darkenBgProgress = 0;
  }
  fill(COL_EXIT_BTN);
  rect(exitBtnX, exitBtnY, exitBtnW, exitBtnH);
  fill(COL_BLACK);
  textAlign(CENTER);
  text("EXIT", exitBtnX+(exitBtnW/2), exitBtnY+(exitBtnH/2));
  popMatrix();
}

// --------------------
// M E N U   S T A T S
// --------------------
void statsPage() {
  if (overlayScreenY > 0) {
      overlayScreenY -= height/15;
      darkenBgProgress += ceil(70/15);
    } else {
      overlayScreenY = 0;
      darkenBgProgress = 70;
    }
    fill(0);
    textSize(30);
    textAlign(LEFT);
    text("Enemies defeated:"+"\nRuns attempts:"+"\nSuccessful runs:"+"\nDefeats:", width/5, height/5);
    textAlign(RIGHT);
    text(savefile.getInt("mobSlain")+"\n"+savefile.getInt("runNbr")+"\n"+savefile.getInt("winNbr")+"\n"+savefile.getInt("defeatNbr"), width*0.8, height/5);
}

// --------------------
// H E R O   S E L E C T
// --------------------
void drawHeroSelect() {
  for (int i=0; i < heroBanners.length; i++) {
    if (i < heroBanners.length/2) {
      fill(COL_DARK);
      rect((heroSelectX*(i+1))+(heroSelectXOffset*i), height/15*2, heroSelectW, heroSelectH);
      image(heroBanners[i], (heroSelectX*(i+1))+(heroSelectXOffset*i), height/15*2, heroSelectW, heroSelectW/2);
    } else {
      fill(COL_DARK);
      rect((heroSelectX*(i-3+1))+(heroSelectXOffset*(i-3)), height/15*7, heroSelectW, heroSelectH);
      image(heroBanners[i], (heroSelectX*(i-3+1))+(heroSelectXOffset*(i-3)), height/15*7, heroSelectW, heroSelectW/2);
    }
  }
  // image(heroSelectBG, 0, 0, width, height);
  // for loop to draw all character portraits and names
  if (overlayScreenY > 0) {
      overlayScreenY -= height/15;
      darkenBgProgress += ceil(70/15);
    } else {
      overlayScreenY = 0;
      darkenBgProgress = 70;
    }
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
