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
boolean oneFrameExecution = false; // utile pour executer du code pendant 1 frame

// Permet de slide up des overlays dans le main menu
float overlayScreenY;

// Si l'utilisateur a déjà joué
JSONObject savefile;
JSONArray unlockedItems;
int statMobKills;
int statRunNbr;
int statRunWinNbr;
int statRunLoseNbr;
int statMoneyGained;
int statLevelBeaten;

// Les Fichiers JSON
JSONArray allHeroes;
JSONArray allMobs;
JSONObject[] allItems;
JSONArray allAttacks;

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
char titleLastScreen; // Garder un écran afficher quand l'animation quit se passe
PImage titleSign; // Panneau d'arrière-plan quand t'es dans un menu
PImage titleSignPage;

// Écran Choisi ton Héro
PImage[] heroBanners;
float heroSelectX = 200;
float heroSelectW = 188;
float heroSelectH = 225;
float heroSelectXOffset = 6;
final color COL_HOVER = color(0, 0, 0, 30); // couleur de survolement
JSONObject selectedHero; // Héro choisi

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
PImage battleForeground;
PImage heroSprite;
PImage energyCounter;
int roundNbr = 0;
int energyLeft = 3;
int maxEnergy = 3;
IntList fullAbilityDeck; // Contient TOUTES les cartes en inventaire
IntList currentAbilityDeck; // Contient toutes les cartes non discartés
IntList currentAbilityHand; // Contient toutes les cartes dans les mains
float energyCounterPosX = 10; // Positionnement du energy counter
float energyCounterPosY = 95;
float energyCounterSize = 80;

// Battle Display
float hudProgressPosX; // Position X, Y, Width, Height de roundNbr et Money
float hudProgressPosY;
float hudProgressWidth;
float hudProgressHeight;
float hudProgressRounded; // À quel point rounded que le rect est
float hudProgressGutter; // Distance verticale entre roundNbr et Money
color hudProgressColor = color(0, 0, 0, 100);

// Variables des cartes Ability
float battleCardPosX;
float battleCardPosY;
float battleCardWidth;
float battleCardHeight;
float battleCardGutter;

// Font
PFont descFont;

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
    battle();

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

  // Position des éléments HUD dans les combat
  hudProgressPosX = width*0.79; // Position X, Y, Width, Height de roundNbr et Money
  hudProgressPosY = height/75;
  hudProgressWidth = width*0.2;
  hudProgressHeight = height/15;
  hudProgressRounded = 15;
  hudProgressGutter = hudProgressPosY+hudProgressHeight;

  // Cartes Ability
  battleCardPosX = width*0.015;
  battleCardPosY = height*0.74;
  battleCardWidth = width*0.14;
  battleCardHeight = height*0.24;
  battleCardGutter = width*0.026;

  // Font
  descFont = createFont("fonts/undertale-deltarune-text-font-extended.otf", 50);
  textFont(descFont);

  // Array Lists des abilités obtenues
  fullAbilityDeck = new IntList();
  currentAbilityDeck = new IntList();
  currentAbilityHand = new IntList();

  // Inventaire
  bag = new Inventory();
  bag.initializeInventory();

  // Load les JSONs
  allHeroes = loadJSONArray("./json/heroes.json");
  allMobs = loadJSONArray("./json/enemies.json");
  allItems = bag.getAllItems();
  allAttacks = loadJSONArray("./json/attacks.json");
}

// --------------------
// LOAD TOUT LES ASSETS DE BASE
// --------------------
void loadBasicAssets() {
  // Load all PImages here
  titleBG = loadImage("menus/menu_title_background.png");
  titleStartButton = loadImage("menus/menu_title_startButton.png");
  titleOtherButton = loadImage("menus/menu_title_otherButton.png");
  titleSign = loadImage("menus/menu_title_sign.png");
  titleSignPage = loadImage("menus/menu_title_signPage.png");

  battleBackground = loadImage("backgrounds/DEBUG_background.png");
  battleForeground = loadImage("backgrounds/DEBUG_foreground.png");
  energyCounter = loadImage("menus/battle_energy_sphere.png");

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
      if (isOnHeroSelect) {
        titleLastScreen = 'h'; // Met le last screen check a Hero
      }
      if (isOnStatsPage) {
        titleLastScreen = 's'; // Met le last screen check a Stats
      }
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
        } else if (savefile.getBoolean("char"+i+"_unlocked")) {
          isThisHeroSelected = mouseDetection((heroSelectX*(i-3+1))+(heroSelectXOffset*(i-3)), height/15*7, heroSelectW, heroSelectH);
        }
        if (isThisHeroSelected) {
          hero = new Player(i);
          isOnTitleScreen = false;
          isOnHeroSelect = false;
          isGameStarted = true;
          oneFrameExecution = true;
          selectedHero = hero.getSelectedHero();

          // Ajoute les cartes ability appropriées
          JSONArray getAbilityList = selectedHero.getJSONArray("abilityList");
          for (int j = 0; j < getAbilityList.size(); j++) {
            fullAbilityDeck.append(getAbilityList.getInt(j));
          }
          if (savefile.getInt("char"+hero.getID()+"_lvl") >= 1) {
            fullAbilityDeck.append(selectedHero.getInt("lv1Ability"));
            if (savefile.getInt("char"+hero.getID()+"_lvl") >= 2) {
              fullAbilityDeck.append(selectedHero.getInt("lv2Ability"));
              if (savefile.getInt("char"+hero.getID()+"_lvl") >= 4) {
                fullAbilityDeck.append(selectedHero.getInt("lv4Ability"));
                if (savefile.getInt("char"+hero.getID()+"_lvl") == 5) {
                  fullAbilityDeck.append(selectedHero.getInt("lv5Ability"));
                }
              }
            }
          }
          // Ajoute le full deck au current deck débuter
          for (int j = 0; j < fullAbilityDeck.size(); j++) {
            currentAbilityDeck.append(fullAbilityDeck.get(j));
          }
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
    } else if (keyInput == -1) {
      bag.loseHeldItem(0);
    }
    if (key == 'r') {
      rerollAbilityHand();
    }
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
  fill(COL_WHITE);
  textSize(24);
  textAlign(CENTER);
  text("Start Game", startMenuTextOffset, heroSelectButtonY+(startMenuButtonHeight/2));
  text("Stats", startMenuTextOffset, statsPageButtonY+(startMenuButtonHeight/2));
  text("Quit", startMenuTextOffset, quitAppButtonY+(startMenuButtonHeight/2));

  // Détection de survolement des boutons de l'écran titre
  if (!isOnHeroSelect && !isOnStatsPage) {
    fill(COL_HOVER);
    if (mouseDetection(startMenuButtonX, heroSelectButtonY, startMenuButtonWidth, startMenuButtonHeight)) {
      rect(startMenuButtonX, heroSelectButtonY, startMenuButtonWidth, startMenuButtonHeight);
    } else if (mouseDetection(startMenuButtonX, statsPageButtonY, startMenuButtonWidth, startMenuButtonHeight)) {
      rect(startMenuButtonX, statsPageButtonY, startMenuButtonWidth, startMenuButtonHeight);
    } else if (mouseDetection(startMenuButtonX, quitAppButtonY, startMenuButtonWidth, startMenuButtonHeight)) {
      rect(startMenuButtonX, quitAppButtonY, startMenuButtonWidth, startMenuButtonHeight);
    }
  }

  // Écran qui pop up
  fill(COL_BLACK, darkenBgProgress);
  rect(0, 0, width, height);
  pushMatrix();
  translate(0, overlayScreenY);
  fill(0);

  image(titleSign, 0, 0, width, height); // Image du panneau dans l'arrière-plan

  if (isOnHeroSelect) { // Dessine Hero Select
    drawHeroSelect();
  } else if (isOnStatsPage) { // Dessine Stats Page
    statsPage();
  } else if (overlayScreenY < height) { // Animation Lowers
    if (titleLastScreen == 'h') { // Dessine l'écran héro
      drawHeroSelect();
    } else if (titleLastScreen == 's') { // Dessine l'écran stats
      statsPage();
    }
    overlayScreenY += height/15;
    darkenBgProgress -= ceil(70/15);
  } else { // Animation Off
    overlayScreenY = height;
    darkenBgProgress = 0;
  }

  // Bouton Quitter
  fill(COL_EXIT_BTN);
  rect(exitBtnX, exitBtnY, exitBtnW, exitBtnH);
  fill(COL_BLACK);
  textSize(24);
  textAlign(CENTER);
  text("EXIT", exitBtnX+(exitBtnW/2), exitBtnY+(exitBtnH/2));

  // Si le bouton Exit est survolé
  if (mouseDetection(exitBtnX, exitBtnY, exitBtnW, exitBtnH)) {
    fill(COL_HOVER);
    rect(exitBtnX, exitBtnY, exitBtnW, exitBtnH);
  }
  popMatrix();
}

// --------------------
// M E N U   S T A T S
// --------------------
void statsPage() {
  image(titleSignPage, 0, 0, width, height); // Page en arrière-plan

  fill(0);
  textSize(30);
  textLeading(66);
  textAlign(LEFT); // Affiche le nom des stats
  text("Enemies defeated:"+"\nRuns attempts:"+"\nSuccessful runs:"+"\nDefeats:"+"\nMoney gained:"+"\nLevels conquered:"+"\nItems discovered:", width/5, height/5);

  textAlign(RIGHT); // Affiche les stats sortis du fichier sauvegarde
  text(savefile.getInt("mobSlain")+"\n"+savefile.getInt("runNbr")+"\n"+savefile.getInt("winNbr")+"\n"+savefile.getInt("defeatNbr")+"\n$"+savefile.getInt("moneyGained")+"\n"+savefile.getInt("levelBeaten")+"/5\n"+unlockedItems.size()+"/60", width*0.8, height/5);
  textLeading(48);
  if (isOnStatsPage) { // Si l'écran n'est pas en cours d'être quitter
    if (overlayScreenY > 0) { // Animation Rising
      overlayScreenY -= height/15;
      darkenBgProgress += ceil(70/15);
    } else { // Animation Standby
      overlayScreenY = 0;
      darkenBgProgress = 70;
    }
  }
}

// --------------------
// H E R O   S E L E C T
// --------------------
void drawHeroSelect() {
  for (int i=0; i < heroBanners.length; i++) { // Loop tout les héros
    float xPos;
    float yPos;
    float textOffset = 2;
    fill(COL_DARK);
    textSize(16);
    textAlign(CENTER);
    JSONObject currentHero = allHeroes.getJSONObject(i); // Collecte le héro actuel
    if (i < heroBanners.length/2) { // Si c'est la top row
      xPos = (heroSelectX*(i+1))+(heroSelectXOffset*i); // Position X de la carte
      yPos = height/15*2; // Position Y de la carte

      rect(xPos, yPos, heroSelectW, heroSelectH); // Backdrop
      image(heroBanners[i], xPos, yPos, heroSelectW, heroSelectW/2); // Image héro

      fill(COL_WHITE); // Nom héro
      text(currentHero.getString("name"), xPos+heroSelectW/2, height/15*4.25);

      textSize(10); // Description héro
      text(currentHero.getString("description"), xPos, height/15*4.4, heroSelectW-textOffset, heroSelectH/3);

      fill(COL_GRAY); // Bar d'exp vide
      rect(xPos+heroSelectW/10, height/15*5.5, heroSelectW/5*4, heroSelectH/32);
      fill(COL_DEF); // Bar d'exp pleine
      rect(xPos+heroSelectW/10, height/15*5.5, map(savefile.getInt("char"+i+"_exp"), 0, (savefile.getInt("char"+i+"_lvl")+1)*100, 0, heroSelectW/5*4), heroSelectH/32);
      fill(COL_WHITE); // Texte niveau
      textSize(12);
      text("Lv"+savefile.getInt("char"+i+"_lvl"), xPos+heroSelectW/10, height/15*5.65);

      textSize(11); // Stats
      text("ATK:"+currentHero.getInt("attack")+"  DEF:"+currentHero.getInt("defense")+"  HP:"+currentHero.getInt("maxHp"), xPos+heroSelectW/2, height/15*6.25);
    } else {
      xPos = (heroSelectX*(i-3+1))+(heroSelectXOffset*(i-3)); // Position X de la carte
      yPos = height/15*7; // Position Y de la carte

      rect(xPos, yPos, heroSelectW, heroSelectH); // Backdrop
      if (savefile.getBoolean("char"+i+"_unlocked")) {
        image(heroBanners[i], xPos, yPos, heroSelectW, heroSelectW/2); // Image héro

        fill(COL_WHITE); // Nom héro
        text(currentHero.getString("name"), xPos+heroSelectW/2, height/15*9.25);

        textSize(10); // Description héro
        text(currentHero.getString("description"), xPos, height/15*9.4, heroSelectW-textOffset, heroSelectH/3);

        fill(COL_GRAY); // Bar d'exp vide
        rect(xPos+heroSelectW/10, height/15*10.5, heroSelectW/5*4, heroSelectH/32);
        fill(COL_DEF); // Bar d'exp pleine
        rect(xPos+heroSelectW/10, height/15*10.5, map(savefile.getInt("char"+i+"_exp"), 0, (savefile.getInt("char"+i+"_lvl")+1)*100, 0, heroSelectW/5*4), heroSelectH/32);
        fill(COL_WHITE); // Texte niveau
        textSize(12);
        text("Lv"+savefile.getInt("char"+i+"_lvl"), xPos+heroSelectW/10, height/15*10.65);

        textSize(11); // Stats
        text("ATK:"+currentHero.getInt("attack")+"  DEF:"+currentHero.getInt("defense")+"  HP:"+currentHero.getInt("maxHp"), xPos+heroSelectW/2, height/15*11.25);
      } else {
        textSize(28);
        fill(COL_WHITE); // texte ???
        text("???", xPos+heroSelectW/2, yPos+yPos/6);

        textSize(12); // Description de comment débloquer
        text(currentHero.getString("unlockRequirement"), xPos, height/15*9.4, heroSelectW-textOffset, heroSelectH/3);
      }
    }
    if (mouseDetection(xPos, yPos, heroSelectW, heroSelectH)) {
      if (i <= 2 || savefile.getBoolean("char"+i+"_unlocked")) {
        fill(COL_HOVER);
        rect(xPos, yPos, heroSelectW, heroSelectH);
      }
    }
  }

  if (isOnHeroSelect) { // Si l'écran n'est pas en cours d'être quitter
    if (overlayScreenY > 0) { // Animation Rising
      overlayScreenY -= height/15;
      darkenBgProgress += ceil(70/15);
    } else { // Animation Standby
      overlayScreenY = 0;
      darkenBgProgress = 70;
    }
  }
}

// --------------------
// B A T T L E   S C R E E N
// --------------------
void battle() {
  if (oneFrameExecution) {
    rerollAbilityHand();
    oneFrameExecution = false;
  }
  image(battleBackground, 0, 0, width, height); // Arrière-plan
  hero.display(); // Affiche le héro sprite

  // Nombre d'énergie
  image(energyCounter, energyCounterPosX, energyCounterPosY, energyCounterSize, energyCounterSize);
  textSize(26);
  fill(COL_BLACK); // Texte nombre d'énergie
  text(energyLeft+"/"+maxEnergy, energyCounterPosX+energyCounterSize/2, energyCounterPosY+energyCounterSize/5*3);

  bag.itemDisplay(); // affiche tout les items
  // ENEMY DISPLAY HERE
  image(battleForeground, 0, 0, width, height); // Avant-plan

  fill(hudProgressColor); // Rectangles Round et Money
  rect(hudProgressPosX, hudProgressPosY, hudProgressWidth, hudProgressHeight, hudProgressRounded);
  rect(hudProgressPosX, hudProgressPosY+hudProgressGutter, hudProgressWidth, hudProgressHeight, hudProgressRounded);

  fill(COL_WHITE); // Texte Round et Money
  textAlign(CENTER);
  textSize(28);
  text("ROUND "+roundNbr, hudProgressPosX+hudProgressWidth/2, hudProgressPosY+hudProgressHeight/6*4);
  text("$"+bag.getMoney(), hudProgressPosX+hudProgressWidth/2, hudProgressPosY+hudProgressHeight/6*4+hudProgressGutter);

  // Cartes ability
  for (int i = 0; i < currentAbilityHand.size(); i++) {
    drawAbilityCard(battleCardPosX + battleCardWidth*i + battleCardGutter*i, allAttacks.getJSONObject(currentAbilityHand.get(i)), i);
  }

  // DEBUG INFO --------------------
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

// Dessine une carte attaque
void drawAbilityCard(float cardX, JSONObject cardAbility, int handIndex) {
  color cardColor;
  float inputCircleSize = battleCardWidth*0.22;
  if (cardAbility.getInt("colorType") == 0) { // Applique la couleur rouge
    cardColor = COL_ATK;
  } else if (cardAbility.getInt("colorType") == 1) { // Applique la couleur bleu
    cardColor = COL_DEF;
  } else { // Applique la couleur jaune
    cardColor = COL_STATUS;
  }
  // Arrière-plan de la carte et de la description
  fill(cardColor); // Carte
  rect(cardX, battleCardPosY, battleCardWidth, battleCardHeight);
  fill(COL_WHITE); // Description
  rect(cardX+battleCardWidth/12, battleCardPosY+battleCardHeight*0.45, battleCardWidth/6*5, battleCardHeight*0.5);

  // Info sur l'ability
  fill(COL_BLACK);
  textAlign(CENTER);
  textSize(11); // Nom de l'attaque
  text(cardAbility.getString("name"), cardX+battleCardWidth/2, battleCardPosY+battleCardHeight*0.53, battleCardWidth/6*5);

  textSize(10); // Description de l'attaque
  text(cardAbility.getString("desc"), cardX+battleCardWidth/12, battleCardPosY+battleCardHeight*0.57, battleCardWidth/6*5, battleCardHeight*0.5);

  // Image Placeholder
  fill(COL_DARK);
  rect(cardX+battleCardWidth/12, battleCardPosY+battleCardHeight*0.05, battleCardWidth/6*5, battleCardHeight*0.35);

  // Input Circle
  stroke(cardColor);
  strokeWeight(4);
  fill(COL_DARK);
  circle(cardX+battleCardWidth/2, battleCardPosY, inputCircleSize);
  noStroke();

  // Texte qui dit quel touche appuyer pour utiliser
  fill(COL_WHITE);
  textSize(18);
  text(handIndex+1, cardX+battleCardWidth/2, battleCardPosY+battleCardHeight*0.035);
}

void useAbility() {
  // ability use
}

void rerollAbilityHand() {
  currentAbilityHand.clear(); // Vide la main de l'utilisateur
  currentAbilityDeck.shuffle(); // Mélange le deck
  for (int i = 0; i < 6; i++) { // Rempli la main de l'utilisateur
    if (currentAbilityDeck.size() <= 0) { // Si le deck est vide, rempli-le
      for (int j = 0; j < fullAbilityDeck.size(); j++) {
        currentAbilityDeck.set(j, fullAbilityDeck.get(j));
      }
      currentAbilityDeck.shuffle();
    }
    currentAbilityHand.append(currentAbilityDeck.get(0));
    currentAbilityDeck.remove(0);
  }
  // shuffle deck
  // add from deck to hand while removing from deck. If deck size = 0, deck = full deck
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
    savefile.setInt("moneyGained", 0);
    savefile.setInt("levelBeaten", 0);

    unlockedItems = new JSONArray();
    savefile.setJSONArray("unlockedItems", unlockedItems);

    saveJSONObject(savefile, "data/json/savefile.json");
  } else {
    unlockedItems = savefile.getJSONArray("unlockedItems");
  }
  statMobKills = savefile.getInt("mobSlain");
  statRunLoseNbr = savefile.getInt("defeatNbr");
  statRunNbr = savefile.getInt("runNbr");
  statRunWinNbr = savefile.getInt("winNbr");
  statMoneyGained = savefile.getInt("moneyGained");
  statLevelBeaten = savefile.getInt("levelBeaten");
}

// Sauvegarde un stat augmenté et met à jour la variable contenant la valeur
int statIncrease(int stat, int amountGained, String savefileField) {
  stat += amountGained;
  savefile.setInt(savefileField, stat);
  saveGame();
  return stat;
}

void saveGame() { // Sauvegarde le progrès
  saveJSONObject(savefile, "data/json/savefile.json");
}
