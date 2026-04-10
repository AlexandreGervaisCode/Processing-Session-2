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
boolean isGameStarted = false;
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
final color COL_WHITE = color(255);
final color COL_GRAY = color(127);
final color COL_ATK = color(255, 51, 51);
final color COL_DEF = color(51, 109, 255);
final color COL_STATUS = color(219, 211, 113);
float exitBtnX; // Emplacement des boutons Quitter
float exitBtnY;
float exitBtnW;
float exitBtnH;

// Écran Choisi ton Héro
PImage[] heroBanners;
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

// Variables Battle
PImage battleBackground;
PImage heroSprite;
int roundNbr = 0;

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
  if (isOnTitleScreen) { // Dessine l'écran titre
    isPlayerTurn = false;
    isInCombat = false;
    drawTitleScreen();
  } else if (isGameStarted) { // Dessine l'écran de combat
    beginGame();
    
    // Once the Player has lost the Game
    if (hero.isDead()) {
      onGameOver();
    }
  }
}

// --------------------
// INITIALIZE LES VARIABLES DANS SET UP
// --------------------
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

// --------------------
// LOAD TOUT LES ASSETS DE BASE
// --------------------
void loadBasicAssets() {
  // Load all PImages here
  titleBG = loadImage("menus/menu_title_background.png");
  titleStartButton = loadImage("menus/menu_title_startButton.png");
  titleOtherButton = loadImage("menus/menu_title_otherButton.png");
  
  battleBackground = loadImage("backgrounds/DEBUG_battle_bg.png");

  heroBanners = new PImage[allHeroes.size()];
  // Load les images Banner
  for (int i=0; i < allHeroes.size(); i++) {
    JSONObject currentHero = allHeroes.getJSONObject(i);
    PImage thisForHero = loadImage(currentHero.getString("bannerSprite"));
    heroBanners[i] = thisForHero;
  }
}

void mousePressed() {
  // --------------------
  // INTERACTIONS ÉCRAN TITRE
  // --------------------
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

    if (isOnHeroSelect && overlayScreenY == 0) { // Choisi un héro et commence la partie
      for (int i=0; i < heroBanners.length; i++) {
        boolean isThisHeroSelected = false;
        if (i < heroBanners.length/2) {
          isThisHeroSelected = mouseDetection((heroSelectX*(i+1))+(heroSelectXOffset*i), height/15*2, heroSelectW, heroSelectH);
        } else {
          isThisHeroSelected = mouseDetection((heroSelectX*(i-3+1))+(heroSelectXOffset*(i-3)), height/15*7, heroSelectW, heroSelectH);
        }
        if (isThisHeroSelected) {
          hero = new Player(i);
          isOnTitleScreen = false;
          isOnHeroSelect = false;
          isGameStarted = true;
        }
      }
    }
  }
  // Check pour si le bouton Exit a été appuyé dans les écrans appropriés
  if ((isOnStatsPage || isOnHeroSelect || isInShop) && mouseDetection(exitBtnX, exitBtnY, exitBtnW, exitBtnH)) {
    isOnStatsPage = false;
    isOnHeroSelect = false;
    isInShop = false;
  }
}

// --------------------
// INTÉRACTIONS AVEC LE CLAVIER
// --------------------
void keyPressed() {
  if (isGameStarted) { // FOR DEBUG ONLY
  int keyInput = int(key)-49; // Ex. Appyer sur la touche 1 redonne 0
    if (keyInput >= 0 && keyInput <= 8) {
      bag.receiveItem(floor(random(60)));
    }
    println(int(key));
  }
  if (isGameStarted && isPlayerTurn) {
    
  }
}

// --------------------
// É C R A N   T I T R E
// --------------------
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
  if (isOnHeroSelect) { // Dessine Hero Select
    drawHeroSelect();
  } else if (isOnStatsPage) { // Dessine Stats Page
    statsPage();
  } else if (overlayScreenY < height) { // Animation Lowers
    overlayScreenY += height/15;
    darkenBgProgress -= ceil(70/15);
  } else { // Animation Off
    overlayScreenY = height;
    darkenBgProgress = 0;
  }
  fill(COL_EXIT_BTN);
  rect(exitBtnX, exitBtnY, exitBtnW, exitBtnH);
  fill(COL_BLACK);
  textSize(24);
  textAlign(CENTER);
  text("EXIT", exitBtnX+(exitBtnW/2), exitBtnY+(exitBtnH/2));
  popMatrix();
}

// --------------------
// M E N U   S T A T S
// --------------------
void statsPage() {
  if (overlayScreenY > 0) { // Animation Rising
    overlayScreenY -= height/15;
    darkenBgProgress += ceil(70/15);
  } else { // Animation Standby
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
    float xPos;
    fill(COL_DARK);
    textSize(16);
    textAlign(CENTER);
    JSONObject currentHero = allHeroes.getJSONObject(i);
    if (i < heroBanners.length/2) {
      xPos = (heroSelectX*(i+1))+(heroSelectXOffset*i);
      rect(xPos, height/15*2, heroSelectW, heroSelectH);
      image(heroBanners[i], xPos, height/15*2, heroSelectW, heroSelectW/2);
      fill(COL_WHITE);
      text(currentHero.getString("name"), xPos+heroSelectW/2, height/15*4.25);
      textSize(12);
      text(currentHero.getString("description"), xPos, height/15*4.5, heroSelectW, heroSelectH/3);
      fill(COL_GRAY);
      rect(xPos+heroSelectW/10, height/15*5.5, heroSelectW/5*4, heroSelectH/32);
      fill(COL_DEF);
      rect(xPos+heroSelectW/10, height/15*5.5, map(savefile.getInt("char"+i+"_exp"), 0, (savefile.getInt("char"+i+"_lvl")+1)*100, 0, heroSelectW/5*4), heroSelectH/32);
      fill(COL_WHITE);
      textSize(14);
      text("Lv"+savefile.getInt("char"+i+"_lvl"), xPos+heroSelectW/10, height/15*5.65);
      textSize(13);
      text("ATK: "+currentHero.getInt("attack")+"  DEF: "+currentHero.getInt("defense")+"  HP: "+currentHero.getInt("maxHp"), xPos+heroSelectW/2, height/15*6.25);
    } else {
      xPos = (heroSelectX*(i-3+1))+(heroSelectXOffset*(i-3));
      rect(xPos, height/15*7, heroSelectW, heroSelectH);
      image(heroBanners[i], xPos, height/15*7, heroSelectW, heroSelectW/2);
      fill(COL_WHITE);
      text(currentHero.getString("name"), xPos+heroSelectW/2, height/15*9.25);
      textSize(12);
      text(currentHero.getString("description"), xPos, height/15*9.5, heroSelectW, heroSelectH/3);
      fill(COL_GRAY);
      rect(xPos+heroSelectW/10, height/15*10.5, heroSelectW/5*4, heroSelectH/32);
      fill(COL_DEF);
      rect(xPos+heroSelectW/10, height/15*10.5, map(savefile.getInt("char"+i+"_exp"), 0, (savefile.getInt("char"+i+"_lvl")+1)*100, 0, heroSelectW/5*4), heroSelectH/32);
      fill(COL_WHITE);
      textSize(14);
      text("Lv"+savefile.getInt("char"+i+"_lvl"), xPos+heroSelectW/10, height/15*10.65);
      textSize(13);
      text("ATK: "+currentHero.getInt("attack")+"  DEF: "+currentHero.getInt("defense")+"  HP: "+currentHero.getInt("maxHp"), xPos+heroSelectW/2, height/15*11.25);
    }
  }
  // image(heroSelectBG, 0, 0, width, height);
  // for loop to draw all character portraits and names
  if (overlayScreenY > 0) { // Animation Rising
    overlayScreenY -= height/15;
    darkenBgProgress += ceil(70/15);
  } else { // Animation Standby
    overlayScreenY = 0;
    darkenBgProgress = 70;
  }
}

void beginGame() {
  image(battleBackground, 0, 0, width, height);
  hero.display();
  // bag.itemDisplay();
  // DEBUG INFO
  fill(255, 0, 0);
  textAlign(CENTER);
  textSize(40);
  text(hero.getName(), width/2, height/2);
}

void onGameOver() {
  bag.loseMoney(bag.getMoney()); // Réduit l'argent à zéro
  roundNbr = 0;
  bag.initializeInventory();
}

// --------------------
// T I M E R
// --------------------
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
// S A V E   F I L E
// --------------------
void savefileLoad() {
  // Load le fichier de sauvegarde
  savefile = loadJSONObject("json/savefile.json");
  if (savefile == null) { // Crée le fichier de sauvegarde
    savefile = new JSONObject();
    // Met les tout les persos au niveau 1, 0 exp. Perso 3, 4 et 5 sont locked
    savefile.setInt("char0_exp", 0);
    savefile.setInt("char0_lvl", 0);

    savefile.setInt("char1_exp", 0);
    savefile.setInt("char1_lvl", 0);

    savefile.setInt("char2_exp", 0);
    savefile.setInt("char2_lvl", 0);

    savefile.setInt("char3_exp", 0);
    savefile.setInt("char3_lvl", 0);
    savefile.setBoolean("char3_unlocked", false);

    savefile.setInt("char4_exp", 0);
    savefile.setInt("char4_lvl", 0);
    savefile.setBoolean("char4_unlocked", false);

    savefile.setInt("char5_exp", 0);
    savefile.setInt("char5_lvl", 0);
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
