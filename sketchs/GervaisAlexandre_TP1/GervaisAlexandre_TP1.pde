/*
 * Titre: EDM1700 Travail Pratique 1: "WANTED"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions: Les instructions pour utiliser mon programme.
 * Description du projet
 * Notes: Quelques notes optionnelles à l'intention du correcteur.
 */

// boucle for de 30 objets inanimés
// 1 objet animé
// 1 perso intéractif avec la souris

// Médias --------------------
// Search Icons
PImage searchMario;
PImage searchLuigi;
PImage searchWario;
PImage searchYoshi;
// Poster Icons
PImage posterMario;
PImage posterLuigi;
PImage posterWario;
PImage posterYoshi;
// Variables pour changer dynamiquement les personnages
PImage wrongChar1;
PImage wrongChar2;
PImage wrongChar3;
PImage targetChar;
PImage posterChar;
// Police
PFont wantedFont;
// Couleurs
final color COL_BG = color(0); // Noir
final color COL_TEXT = color(255, 231, 55); // Jaune
final color COL_SHOP_TOP_BG = color(119, 200, 238); // Bleu
final color COL_SHOP_TOP_STROKE = color(67, 121, 203); // Stroke Bleu
final color COL_SHOP_BOTTOM_BG = color(185); // Gris
final color COL_SHOP_BOTTOM_STROKE = color(130); // Stroke Gris

// Controle du jeu --------------------
boolean isSearching; // Permet de détecter si le jeu est en cours
boolean isGameOver; // Permet de détecter si y'a un Game Over
boolean isInTransition; // Permet de détecter si le joueur est en transition
int wantedCharIndex; // Permet de savoir quel perso doit être trouvé
float luigiChance = 0; // calcule les chances que Luigi doit être trouvé
float timeLeft; // Temps restant avant que le jeu fini
float transitionTime; // Temps de transition entre les rounds
int currentScore; // Pointage
final float ERROR_MARGIN = 5; // Marge d'erreur permise
final int FLOOR_MIN_CHAR_INSTANCES = 4; // La valeur minimale de minCharInstances
final int FLOOR_MAX_CHAR_INSTANCES = 12; // La valeur minimale de maxCharInstances
int minCharInstances = FLOOR_MIN_CHAR_INSTANCES; // Controle combien de persos minimum affiché
int maxCharInstances = FLOOR_MAX_CHAR_INSTANCES; // Controle combien de persos maximum affiché
final int CAP_MIN_CHAR_INSTANCES = 50; // La valeur maximale de minCharInstances
final int CAP_MAX_CHAR_INSTANCES = 64; // La valeur maximale de maxCharInstances

// Coordonées et tailles
final float OFFSET = 10; // Offset pour ne pas avoir les perso sur les coins
final int SEARCH_SIZE = 55; // Définit la taille des images à chercher
final int POSTER_SIZE = 150; // Définit la taille de l'image du poster
float charMinPosX; // Défini la posX minimum des search icons
float charMaxPosX; // Défini la posX maximale des search icons
float charMinPosY; // Défini la posY minimum des search icons
float charMaxPosY; // Défini la posY maximale des search icons
float targetPosX; // Garde en mémoire la posX de la cible
float targetPosY; // Garde en mémoire la posY de la cible
float targetSizeUp = 5; // Controle a quel point la cible est plus grand
float topScreenHeight; // Taille de l'écran supérieur

// Variables reliés au shop
final float SHOP_KEEPER_SIZE = 200; // Taille du shopkeeper
final float SHOP_SLOT = 100; // Taille d'un slot d'item dans le shop
final float SHOP_ITEM = SHOP_SLOT-10; // Taille d'un item dans le shop
final float SHOP_ITEM_OFFSET = 5; // Offset des item dans le shop
float shopSlotPosX; // Position X des Item Slots
float shopSlotPosY; // Position Y des Item Slots
float shopExitPosX; // Position X du bouton quitter
float shopExitPosY; // Position X du bouton quitter
boolean isInMenu = false; // Si l'utilisateur est dans un menu
int kromerAmount = 0; // Montant d'argent
int itemKeygenPrice = 3000; // Prix des objets
int itemGlassesPrice = 1500;
int itemScarfPrice = 750;
int itemPotionPrice = 2000;
boolean isKeygenGot = false;
int transitionHiddenValue; // Permet d'avoir des events secrets
// Shop Sprites
PImage shopKeeper;
PImage itemKeygen;
PImage itemGlasses;
PImage itemScarf;
PImage itemPotion;

// Pre-loading --------------------
void setup() {
  // Taille de la fenêtre
  size(700, 700);
  // Loading search icons
  searchMario = loadImage("char_m_search.png");
  searchLuigi = loadImage("char_l_search.png");
  searchWario = loadImage("char_w_search.png");
  searchYoshi = loadImage("char_y_search.png");
  // Loading poster icons
  posterMario = loadImage("char_m_close.png");
  posterLuigi = loadImage("char_l_close.png");
  posterWario = loadImage("char_w_close.png");
  posterYoshi = loadImage("char_y_close.png");
  // Loading Font
  wantedFont = createFont("sm-64-ds-usa-font.otf", 128);
  // Loading Shop Sprites
  itemKeygen = loadImage("item_keygen.png");
  itemGlasses = loadImage("item_glasses.png");
  itemScarf = loadImage("item_scarf.png");
  itemPotion = loadImage("item_potion.png");
  // Définit les extrêmités de placement de personnages
  charMinPosX = OFFSET;
  charMaxPosX = width-OFFSET-(SEARCH_SIZE);
  charMinPosY = height/3+OFFSET+(SEARCH_SIZE/2);
  charMaxPosY = height-OFFSET-(SEARCH_SIZE);
  // Commence le timer à 1 minute
  timeLeft = 30;
  topScreenHeight = height/3;
  shopSlotPosX = width/3-(SHOP_SLOT/2);
  shopSlotPosY = (height-topScreenHeight)/2-(SHOP_SLOT/2);
  shopExitPosX = width/16;
  shopExitPosY = height/12*11;
  noStroke();
}

void draw() {
  // Réalise ce code 1 seule fois par minigame round --------------------
  if (!isSearching && !isInTransition && !isGameOver) {
    background(COL_BG);
    resetCharIndex();
    // Décide le nombre d'instances chaque mauvais perso vont apparaitres
    createChars();
    // Ce booléan permet de décider les positions aléatoires 1 seule fois
    isSearching = true;
    // fun thingy to play with
    // windowMove(floor(random(displayWidth-width)), floor(random(displayHeight-height)));
  }
  // S'active à chaque frame que le joueur cherche --------------------
  if (isSearching && !isGameOver) {
    drawPoster();
    isGameOver = gameOverCheck();
  }
  // S'active durant les transition entre les rounds --------------------
  if (isInTransition && !isInMenu) {
    transitionTime = timer(transitionTime);
    if (transitionTime>0) {
      fill(COL_TEXT);
      rect(0, 0, width, height);
      createCharacter(targetPosX, targetPosY, targetChar);
    } else {
       if (transitionHiddenValue >= 90 && currentScore>25) {
         isInMenu = true;
         shop();
       } else if (transitionHiddenValue == 87 && currentScore>25) {
         // where's waldo
         // isInMenu = true;
       } else if (transitionHiddenValue == 18 && currentScore>25) {
         // Smash
         // isInMenu = true;
       } else {
         println(transitionHiddenValue);
         isInTransition = !isInTransition;
       }
    }
  }
  
  // Si le joueur échoue, reset tout
  if (isGameOver) {
    fill(COL_BG);
    rect(0, 0, width, height);
    fill(COL_TEXT);
    textAlign(CENTER);
    textSize(35);
    text("GAME OVER", width/2, height/2);
    textSize(25);
    text("APPUYER SUR UNE TOUCHE POUR CONTINUER", width/2, height/4*3);
    if (keyPressed) {
      isSearching = false;
      isInTransition = false;
      luigiChance = 0;
      kromerAmount = 0;
      currentScore = 0;
      minCharInstances = FLOOR_MIN_CHAR_INSTANCES;
      maxCharInstances = FLOOR_MAX_CHAR_INSTANCES;
      timeLeft = 15;
      targetSizeUp = 5;
      isGameOver = false;
    }
  }
}

// Création des personnages --------------------
void createCharacter(float posX, float posY, PImage characterImg) {
  if (characterImg == targetChar) {
    // Met la cible 5 px de plus que les autres pour éviter de l'empilement
    image(characterImg, posX, posY, SEARCH_SIZE+targetSizeUp, SEARCH_SIZE+targetSizeUp);
    // Sauvegarde la position où appuyer
    targetPosX = posX;
    targetPosY = posY;
  } else {
    image(characterImg, posX, posY, SEARCH_SIZE, SEARCH_SIZE);
  }
}
// Re-roll qui sera la cible --------------------
void resetCharIndex() {
  int rngChar = floor(random(100));
  if (luigiChance >= rngChar) {
    wantedCharIndex = 3;
  } else {
    wantedCharIndex = floor(random(0, 3));
  }
  // Normalement, ceci serait fait avec un array, mais ceci devra faire.
  if (wantedCharIndex == 0) { // Si Mario est le perso à chercher
    posterChar = posterMario;
    targetChar = searchMario;
    wrongChar1 = searchYoshi;
    wrongChar2 = searchWario;
    wrongChar3 = searchLuigi;
    windowTitle("WANTED - MARIO");
  } else if (wantedCharIndex == 1) { // Si Yoshi est le perso à chercher
    posterChar = posterYoshi;
    targetChar = searchYoshi;
    wrongChar1 = searchMario;
    wrongChar2 = searchWario;
    wrongChar3 = searchLuigi;
    windowTitle("WANTED - YOSHI");
  } else if (wantedCharIndex == 2) { // Si Wario est le perso à chercher
    posterChar = posterWario;
    targetChar = searchWario;
    wrongChar1 = searchMario;
    wrongChar2 = searchYoshi;
    wrongChar3 = searchLuigi;
    windowTitle("WANTED - WARIO");
  } else if (wantedCharIndex == 3) { // Si Luigi est le perso à chercher
    posterChar = posterLuigi;
    targetChar = searchLuigi;
    wrongChar1 = searchMario;
    wrongChar2 = searchYoshi;
    wrongChar3 = searchWario;
    windowTitle("WANTED - LUIGI");
  }
}
// Crée les instances des personnages --------------------
void createChars() {
  float charInstances = round(random(minCharInstances, maxCharInstances));
  for (float i = 0; i<charInstances; i++) {
    if (i == round(charInstances/2)) { // Fait le perso cible une seule fois
      createCharacter(random(charMinPosX, charMaxPosX), random(charMinPosY, charMaxPosY), targetChar);
    }
    // Fait les persos incorrects en plusieurs exemplaires chacuns
    createCharacter(random(charMinPosX, charMaxPosX), random(charMinPosY, charMaxPosY), wrongChar1);
    createCharacter(random(charMinPosX, charMaxPosX), random(charMinPosY, charMaxPosY), wrongChar2);
    createCharacter(random(charMinPosX, charMaxPosX), random(charMinPosY, charMaxPosY), wrongChar3);
  }
}

// Déssine l'écran supérieur --------------------
void drawPoster() {
  fill(COL_BG);
  // Ceci crée le "Top Screen" du mini-jeu
  rect(0, 0, width, topScreenHeight);
  textFont(wantedFont, 40);
  fill(COL_TEXT);
  textAlign(CENTER);
  timeLeft = timer(timeLeft);
  text(floor(timeLeft)+"s", width/2, topScreenHeight/4);
  textAlign(RIGHT);
  textSize(25);
  text("Score: "+currentScore, width/10*9, topScreenHeight);
  textAlign(LEFT);
  text(kromerAmount+"K", width/10, topScreenHeight);
  image(posterChar, width/2-(POSTER_SIZE/2), topScreenHeight/3*2-(POSTER_SIZE/2), POSTER_SIZE, POSTER_SIZE);
}

// Détection de réussite/échec ---------------------
void mousePressed() {
  if (isSearching) {
    if (mouseX>=targetPosX && mouseX<=targetPosX+SEARCH_SIZE &&
      mouseY>=targetPosY-ERROR_MARGIN && mouseY<=targetPosY+SEARCH_SIZE+ERROR_MARGIN) {
      currentScore++;
      timeLeft += 15;
      // Augmente les chances que Luigi soit la cible
      if (luigiChance < 50) {
        luigiChance+=floor(random(1, 5));
        if (luigiChance>50) { // Pour ne pas dépasser le max voulu
          luigiChance=50;
        }
      }
      // Augmente les nombres d'instances minimum
      if (minCharInstances < CAP_MIN_CHAR_INSTANCES) {
        minCharInstances += floor(random(2, 4));
        if (minCharInstances > CAP_MIN_CHAR_INSTANCES) { // Pour ne pas dépasser le max voulu
          minCharInstances = CAP_MIN_CHAR_INSTANCES;
        }
      }
      // Augmente les nombres d'instances maximum
      if (maxCharInstances < CAP_MAX_CHAR_INSTANCES) {
        maxCharInstances += floor(random(2, 5));
        if (maxCharInstances > CAP_MAX_CHAR_INSTANCES) { // Pour ne pas dépasser le max voulu
          maxCharInstances=CAP_MAX_CHAR_INSTANCES;
        }
      }
      // Si la cible est Mario ou Wario, gagne 1/3 max argent
      if (wantedCharIndex == 0 || wantedCharIndex == 2) {
        kromerAmount += floor(random(minCharInstances/3, maxCharInstances/3));
      } else if (wantedCharIndex == 1) { // Si Yoshi, gagne 2/3 max argent
        kromerAmount += floor(random(minCharInstances/3*2, maxCharInstances/3*2));
      } else { // Si Luigi, gagne max argent
        kromerAmount += floor(random(minCharInstances, maxCharInstances));
      }
      transitionTime = 3;
      isInTransition = true;
      transitionHiddenValue = floor(random(100));
      if (key == 'g') {
        currentScore = 26;
        transitionHiddenValue = 90;
      }
      isSearching = false;
    } else {
      timeLeft -= 10;
    }
  }
  if (isInMenu) {
    // Si le user essaye d'acheter un item
    if (mouseX>=shopSlotPosX && mouseX<=shopSlotPosX+SHOP_SLOT &&
      mouseY>=shopSlotPosY && mouseY<=shopSlotPosY+SHOP_SLOT) { // Glasses
        purchaseItem(0);
      } else if (mouseX>=shopSlotPosX*2 && mouseX<=shopSlotPosX*2+SHOP_SLOT &&
      mouseY>=shopSlotPosY && mouseY<=shopSlotPosY+SHOP_SLOT) { // Scarf
        purchaseItem(1);
      } else if (mouseX>=shopSlotPosX && mouseX<=shopSlotPosX+SHOP_SLOT &&
      mouseY>=shopSlotPosY*2 && mouseY<=shopSlotPosY*2+SHOP_SLOT) { // Potion
        purchaseItem(2);
      } else if (mouseX>=shopSlotPosX*2 && mouseX<=shopSlotPosX*2+SHOP_SLOT &&
      mouseY>=shopSlotPosY*2 && mouseY<=shopSlotPosY*2+SHOP_SLOT) { // Keygen
        purchaseItem(3);
      } else if (mouseX>=shopExitPosX && mouseX<=shopExitPosX+(width*3) &&
      mouseY>=shopExitPosX && mouseY<=shopExitPosX+(height/12)) {
        frameRate(60);
        isInMenu = !isInMenu;
      }
  }
}

// Timer utilisé à plusieurs places --------------------
float timer(float countdown) {
  if (countdown > 0) {
    countdown-=1/frameRate;
  }
  return countdown;
}

// Check si le joueur à perdu --------------------
boolean gameOverCheck() {
  return timeLeft<=0;
}

void purchaseItem(int itemIndex) {
  if (itemIndex == 0 && kromerAmount >= itemGlassesPrice) {
    kromerAmount -= itemGlassesPrice;
    targetSizeUp+=5;
    shopKeeper = loadImage("npc_shop_success.png");
  } else if (itemIndex == 1 && kromerAmount >= itemScarfPrice) {
    kromerAmount -= itemScarfPrice;
    luigiChance=0;
    shopKeeper = loadImage("npc_shop_success.png");
  } else if (itemIndex == 2 && kromerAmount >= itemPotionPrice) {
    kromerAmount -= itemPotionPrice;
    timeLeft+=45;
    shopKeeper = loadImage("npc_shop_success.png");
  } else if (itemIndex == 3 && kromerAmount >= itemKeygenPrice) {
    kromerAmount -= itemKeygenPrice;
    isKeygenGot = true;
    shopKeeper = loadImage("npc_shop_success.png");
  } else {
    shopKeeper = loadImage("npc_shop_poor.png");
  }
}

void shop() {
  // 4 items : KEYGEN (crashes), B.Shot Glasses (+targetSize)
  // PuppetScarf (luigiChance=0), S.Potion (+45 timeLeft)
  shopKeeper = loadImage("npc_shop_neutral.png");
  frameRate(1);
  for (float x = 0; x<width; x+=width/5) {
    for (float y = 0; y<height; y+=height/15) {
      if (y<=topScreenHeight) {
        fill(COL_SHOP_TOP_BG);
        stroke(COL_SHOP_TOP_STROKE);
      } else {
        fill(COL_SHOP_BOTTOM_BG);
        stroke(COL_SHOP_BOTTOM_STROKE);
      }
      rect(x, y, width/5, height/12);
    }
  }
  // Dessine le Shopkeeper
  image(shopKeeper, width-SHOP_KEEPER_SIZE, topScreenHeight-SHOP_KEEPER_SIZE, SHOP_KEEPER_SIZE, SHOP_KEEPER_SIZE);
  fill(COL_SHOP_TOP_BG);
  stroke(COL_SHOP_TOP_STROKE);
  // Place les slots pour les items
  square(shopSlotPosX, shopSlotPosY, SHOP_SLOT);
  square(shopSlotPosX, shopSlotPosY*2, SHOP_SLOT);
  square(shopSlotPosX*2, shopSlotPosY, SHOP_SLOT);
  square(shopSlotPosX*2, shopSlotPosY*2, SHOP_SLOT);
  // Place les items dans les slots
  image(itemGlasses, shopSlotPosX+SHOP_ITEM_OFFSET, shopSlotPosY+SHOP_ITEM_OFFSET, SHOP_ITEM, SHOP_ITEM);
  image(itemScarf, shopSlotPosX*2+SHOP_ITEM_OFFSET, shopSlotPosY+SHOP_ITEM_OFFSET, SHOP_ITEM, SHOP_ITEM);
  image(itemPotion, shopSlotPosX+SHOP_ITEM_OFFSET, shopSlotPosY*2+SHOP_ITEM_OFFSET, SHOP_ITEM, SHOP_ITEM);
  image(itemKeygen, shopSlotPosX*2+SHOP_ITEM_OFFSET, shopSlotPosY*2+SHOP_ITEM_OFFSET, SHOP_ITEM, SHOP_ITEM);
  // Dessine le bouton quitter
  rect(shopExitPosX, shopExitPosY, width/16*14, height/12);
  textSize(24);
  fill(COL_BG);
  textAlign(CENTER);
  text("S'enfuir", width/2, height/12*11.5);
  noStroke();
}
