/*
 * Titre: EDM1700 Travail Pratique 1: "WANTED"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions: Appuyez sur la tête du personnage recherché avant que la fin.
 * Description du projet: Oh boy. Donc l'utilisateur(trice) est amené a utiliser ses
 talents d'observation pour retrouver un personnage caché. Plus que
 l'utilisateur(trice) réussi, plus que ça devient difficile. Une fois à la
 difficulté maximale, il y a  10% de chance après chaque round qu'un magasin soit
 accessible où il y a divers objets à acheter.
 * Notes: Malgré que tu m'as donné la permission d'utiliser les objects, je ne l'ai
 pas fait car j'avais déjà fait la majorité du jeu de base. Mon code est peu
 messy à cause du montant de lignes, mais j'ai essayer le plus de condenser des
 choses dans des fonctions pour simplifier la lecture. Aussi, un objet dans le
 magasin (Keygen) crash l'application, ceci est intentionnel. C'est pour
 "freak-out" l'utilisateur(trice) et rendre le shop plus "uncanny".
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
PFont shopFont;
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
float spotlightX; // Spotlight position X
float spotlightY; // Spotlight position Y
float spotlightSize = 165; // Taille du spotlight
float spotlightScaleDirection = 0.5; // Si le spotlight grandi ou rétricis
final float MIN_SPOTLIGHT_SIZE = 160; // taille minimum du spotlight
final float MAX_SPOTLIGHT_SIZE = 175; // taille maximum du spotlight
float spotlightSpeed = 3; // Vitesse X du spotlight
final color COL_SPOTLIGHT = color(255, 255, 0, 170);
float spotlightTimer;

// Variables reliés au shop
final float SHOP_KEEPER_SIZE = 200; // Taille du shopkeeper
final float SHOP_SLOT = 100; // Taille d'un slot d'item dans le shop
final float SHOP_ITEM = SHOP_SLOT-10; // Taille d'un item dans le shop
final float SHOP_ITEM_OFFSET = 5; // Offset des item dans le shop
float shopSlotPosXLeft; // Position X des Item Slots à gauche
float shopSlotPosXRight; // Position X des Item Slots à gauche
float shopSlotPosYTop; // Position Y des Item Slots en haut
float shopSlotPosYBottom; // Position Y des Item Slots en bas
float shopExitPosX; // Position X du bouton quitter
float shopExitPosY; // Position X du bouton quitter
float shopExitWidth; // Width X du bouton quitter
float shopExitHeight; // Height du bouton quitter
boolean isInMenu = false; // Si l'utilisateur est dans un menu
boolean hasSeenShop = false; // Cache le montant d'argent si le shop n'a pas été vu
int kromerAmount = 0; // Montant d'argent
int nbrShopVisits = 0; // Nombre de visites au shop pour dialogue dynamique
float shopTimer = 0; // Simule l'effet 1 frame par seconde
String shopDialogue = "EMPTY STRING"; // Dialogue dans le shop
final color COL_SPEECH_BUBBLE = color(202, 238, 255);
int itemKeygenPrice = 1750; // Prix des objets
int itemGlassesPrice = 1050;
int itemScarfPrice = 200;
int itemPotionPrice = 600;
boolean isKeygenGot = false; // Si Keygen a été obtenu
float deathTime = 0.5; // Temps avant que Keygen est effet
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
  shopFont = createFont("undertale-deltarune-text-font-extended.otf", 128);
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
  // Commence le timer
  timeLeft = 30;
  spotlightTimer = 5;
  topScreenHeight = height/3;
  shopSlotPosXLeft = width/3-(SHOP_SLOT/2);
  shopSlotPosXRight = (width/3)*2-(SHOP_SLOT/2);
  shopSlotPosYTop = (height-topScreenHeight)-SHOP_SLOT;
  shopSlotPosYBottom = (height-topScreenHeight)*1.25-SHOP_SLOT;
  shopExitPosX = width/16;
  shopExitPosY = height/12*10.5;
  shopExitWidth = width/16*14;
  shopExitHeight = height/10;
  spotlightX = width*-0.5;
  spotlightY = topScreenHeight/3*1.72;
  noStroke();
}

void draw() {
  // Réalise ce code 1 seule fois par minigame round --------------------
  if (!isSearching && !isInTransition && !isGameOver && !isInMenu) {
    background(COL_BG);

    // Re-randomize la cible
    resetCharIndex();

    // Décide le nombre d'instances chaque mauvais perso vont apparaitres
    createChars();

    // Ce booléan permet de décider les positions aléatoires 1 seule fois
    isSearching = true;
  }
  // S'active à chaque frame que le joueur cherche --------------------
  if (isSearching && !isGameOver) {

    // Dessine l'écran supérieur
    topScreenBackground();
    drawPoster();

    // Check si l'utilisateur(trice) a perdu
    isGameOver = gameOverCheck();

    // Si la Keygen a été achetée
    if (isKeygenGot) {
      activateKeygen();
    }
  }
  // S'active durant les transition entre les rounds --------------------
  if (isInTransition && !isInMenu) {
    levelTransition();
  }

  // Si l'utilisateur est dans le magasin
  if (isInMenu) {
    shop();
  }

  // Si le joueur échoue, reset tout
  if (isGameOver) {
    drawGameOver();
    if (keyPressed) {
      resetValues();
    }
  }
}

// ------------------------------------------
// FONCTIONS QUI CONTROLLE LE JEU
// ------------------------------------------

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
  textFont(wantedFont, 40);
  fill(COL_TEXT);
  textAlign(CENTER);
  timeLeft = timer(timeLeft);
  text(floor(timeLeft)+"s", width/2, topScreenHeight/4);
  textAlign(RIGHT);
  textSize(25);
  text("Score: "+currentScore, width/10*9, topScreenHeight-topScreenHeight/16);
  if (hasSeenShop) {
    textAlign(LEFT);
    textFont(shopFont);
    textSize(25);
    text("$"+kromerAmount, width/10, topScreenHeight-topScreenHeight/16);
    textFont(wantedFont);
  }
  image(posterChar, width/2-(POSTER_SIZE/2), topScreenHeight/3*1.75-(POSTER_SIZE/2), POSTER_SIZE, POSTER_SIZE);
}

void topScreenBackground() {
  fill(COL_BG);
  // Ceci crée le "Top Screen" du mini-jeu
  rect(0, 0, width, topScreenHeight);
  fill(COL_SPOTLIGHT);
  // Permet au spotlight de rétricir/grandir progressivement
  if (spotlightSize >= MAX_SPOTLIGHT_SIZE || spotlightSize <= MIN_SPOTLIGHT_SIZE) {
    spotlightScaleDirection*=-1;
  }
  // Dessine le spotlight
  circle(spotlightX, spotlightY, spotlightSize);
  // Bouge le spotlight de gauche à droite avec une pause au milieu
  if (spotlightX > width*1.5 || spotlightX < width*-0.5) {
    spotlightSpeed *= -1;
  } // Pause au milieu
  if (spotlightX >= width/2-2 && spotlightX <= width/2+2) {
    spotlightTimer = timer(spotlightTimer);
    // grandit/rétricit seulement quand immobile
    spotlightSize += spotlightScaleDirection;
    if (spotlightTimer <= 0) {
      spotlightX += spotlightSpeed;
    }
  } else {
    spotlightTimer = 5;
    spotlightX += spotlightSpeed;
  }
}

// ------------------------------------------
// INTÉRACTIONS AVEC SOURIS
// ------------------------------------------
void mousePressed() {
  if (isSearching) { // Si c'est une intéraction durant le jeu
    // Si la cible est appuyé
    if (mouseX>=targetPosX && mouseX<=targetPosX+SEARCH_SIZE+targetSizeUp &&
      mouseY>=targetPosY-ERROR_MARGIN && mouseY<=targetPosY+SEARCH_SIZE+ERROR_MARGIN+targetSizeUp) {
      currentScore++;
      timeLeft += 10;
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
      /*if (key == 'g') { // Debug Mode for shop
        currentScore = 26;
        transitionHiddenValue = 90;
        kromerAmount=10000;
      }*/
      isSearching = false;
    } else {
      timeLeft -= 10;
    }
  }
  if (isInMenu) {
    // Si le user essaye d'acheter un item
    if (mouseX>=shopSlotPosXLeft && mouseX<=shopSlotPosXLeft+SHOP_SLOT &&
      mouseY>=shopSlotPosYTop && mouseY<=shopSlotPosYTop+SHOP_SLOT) { // Glasses
      purchaseItem(0);
    } else if (mouseX>=shopSlotPosXRight && mouseX<=shopSlotPosXRight+SHOP_SLOT &&
      mouseY>=shopSlotPosYTop && mouseY<=shopSlotPosYTop+SHOP_SLOT) { // Scarf
      purchaseItem(1);
    } else if (mouseX>=shopSlotPosXLeft && mouseX<=shopSlotPosXLeft+SHOP_SLOT &&
      mouseY>=shopSlotPosYBottom && mouseY<=shopSlotPosYBottom+SHOP_SLOT) { // Potion
      purchaseItem(2);
    } else if (mouseX>=shopSlotPosXRight && mouseX<=shopSlotPosXRight+SHOP_SLOT &&
      mouseY>=shopSlotPosYBottom && mouseY<=shopSlotPosYBottom+SHOP_SLOT) { // Keygen
      purchaseItem(3);
    } else if (mouseX>=shopExitPosX && mouseX<=shopExitPosX+shopExitWidth &&
      mouseY>=shopExitPosY && mouseY<=shopExitPosY+shopExitHeight) { // Bouton quitter
      nbrShopVisits++;
      textFont(wantedFont);
      windowMove((displayWidth/2)-(width/2), (displayHeight/2)-(height/2));
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

// Transition entre les rounds --------------------
void levelTransition() {
  transitionTime = timer(transitionTime);
  if (transitionTime>0) {
    fill(COL_TEXT);
    rect(0, 0, width, height); // Met l'arrière-plan jaune
    createCharacter(targetPosX, targetPosY, targetChar); // Affiche la cible
    if (random(2) > 1) { // Reset/randomize la position du spotlight
      spotlightX = width*-0.5;
    } else {
      spotlightX = width*1.5;
    }
  } else {
    // Si la hidden value permet la visite au shop
    if (transitionHiddenValue >= 90 && currentScore>=25) {
      shopKeeper = loadImage("npc_shop_neutral.png");
      isInMenu = true;
      shopTimer = 0.1;
      isInTransition = !isInTransition;
    } else {
      println(transitionHiddenValue);
      isInTransition = !isInTransition;
    }
  }
}

// ----------------------------------------
// FONCTIONS LIÉES AU GAME OVER
// ----------------------------------------

// Check si le joueur à perdu --------------------
boolean gameOverCheck() {
  return timeLeft<=0;
}

// Dessine l'écran Game Over --------------------
void drawGameOver() {
  fill(COL_BG);
  rect(0, 0, width, height);
  fill(COL_TEXT);
  textAlign(CENTER);
  textSize(35);
  text("GAME OVER", width/2, height/2);
  textSize(25);
  text("APPUYER SUR UNE TOUCHE POUR CONTINUER", width/2, height/4*3);
}

// Reset les valeurs après un Game Over --------------------
void resetValues() {
  isSearching = false;
  isInTransition = false;
  isInMenu = false;
  luigiChance = 0;
  kromerAmount = 0;
  currentScore = 0;
  minCharInstances = FLOOR_MIN_CHAR_INSTANCES;
  maxCharInstances = FLOOR_MAX_CHAR_INSTANCES;
  timeLeft = 30;
  targetSizeUp = 5;
  isGameOver = false;
}

// ----------------------------------------
// FONCTIONS LIÉES AU SHOP ET ITEMS
// ----------------------------------------

// Dessine le shop
void shop() {
  // 4 items : KEYGEN (crashes), B.Shot Glasses (+targetSize)
  // PuppetScarf (luigiChance=0), S.Potion (+45 timeLeft)
  shopTimer = timer(shopTimer); // Simule une frameRate de 1
  textFont(shopFont);
  if (shopTimer <= 0) {
    for (float x = 0; x<width; x+=width/5) { // Dessine les briques
      for (float y = 0; y<height; y+=height/15) {
        if (y<=topScreenHeight) { // Dessine les briques à l'écran supérieur
          if (floor(random(3))>0) { // Crée le pattern aléatoire des briques
            fill(COL_SHOP_TOP_BG);
          } else {
            fill(COL_SHOP_TOP_STROKE);
          }
          stroke(COL_SHOP_TOP_STROKE);
        } else { // Dessine les briques à l'écran inférieur
          if (floor(random(3))>0) { // Crée le pattern aléatoire des briques
            fill(COL_SHOP_BOTTOM_BG);
          } else {
            fill(COL_SHOP_BOTTOM_STROKE);
          }
          stroke(COL_SHOP_BOTTOM_STROKE);
        }
        strokeWeight(4);
        rect(x, y, width/5, height/12); // Dessine la brique
      }
    }
    // Dessine le Shopkeeper
    image(shopKeeper, width-SHOP_KEEPER_SIZE, topScreenHeight-SHOP_KEEPER_SIZE+(height/15), SHOP_KEEPER_SIZE, SHOP_KEEPER_SIZE);
    // Manipule la fenêtre
    windowMove(floor(random(displayWidth/5, displayWidth/5*2)), floor(random(displayHeight/5)));
    windowTitle(str(noise(random(15))*random(30)));
    shopTimer = 4;
  }

  // Dialogue --------------------
  // Dialogue basique
  if (nbrShopVisits == 0) {
    textSize(20);
    shopDialogue = "HEY  TOUT  !! C'EST MOI!!! LE\n[[Number 1 Rated Salesman1997]]\nPRÉFÉRÉ DE TOUT LE MO NDE!\nSPAMTON G. SPAMTON!!";
  } else if (nbrShopVisits == 1) {
    textSize(20);
    shopDialogue = "TU NE VEUX PAS ÊTRE UN\n[[BIG SHOT]]? Y'A RIEN DE MAL\nAVEC AVOIR UN PETIT [Plaisir]\nDE TEMPS EN TEMPS.";
  } else if (nbrShopVisits == 2) {
    textSize(20);
    shopDialogue = "INQUIÈTEZ-VOUS PAS ENFANTS\nJE SUIS UN [HommeHonnête].\nJ'AI JUSTE BESOIN DE VOS\n[Détails De Compte] ET LES\n[Numéros sur l'4rriàre]";
  } else if (nbrShopVisits == 3) {
    textSize(20);
    shopDialogue = "Y'a rien qui va mal. Y'a\nRIEN qui va mal. Y'a RIEN\nQUI VA MAL. Y'A RIEN QUI VA\nMAL. Y'A  R1EN Q UI VA\n  MAL";
  } else if (nbrShopVisits == 4) {
    textSize(18);
    shopDialogue = "ATTEND REGARDE!! T'ENTENDS CES\n[Ballons]??? TU ES LE [1000e\nClient(e)]!!. ENTANT QUE\n[Bague Commémorative], JE TE\nPERMET DE TE PROCURER [KeyGen]\nDE MOI A [Un Bas Bas Prix De]";
  } else {
    textSize(30);
    shopDialogue = "ACHÈTE [KEYGEN].";
  }

  // Si un objet est hovered, dit leur effet
  if (mouseX>=shopSlotPosXLeft && mouseX<=shopSlotPosXLeft+SHOP_SLOT &&
    mouseY>=shopSlotPosYTop && mouseY<=shopSlotPosYTop+SHOP_SLOT) { // Glasses
    textSize(20);
    shopDialogue = "WOAH! C'EST LE [Dealmaker]!!\nAVEC CECI, CE SALE DE [Plombier]\nSERA PLUS GRAND ET PLUS\nVISIBLE !! MAIS JAMAIS PLUS\nGRAND QUE [Spamton G.Spamton]!!";
  } else if (mouseX>=shopSlotPosXRight && mouseX<=shopSlotPosXRight+SHOP_SLOT &&
    mouseY>=shopSlotPosYTop && mouseY<=shopSlotPosYTop+SHOP_SLOT) { // Scarf
    textSize(20);
    shopDialogue = "AH LE [Puppet Scarf]... CECI\nVA [Reset] TES CH4NCES DE VOIR\n[Joueur 2] À Z3R0 ! MAIS\nSEULEMENT TEMPORAIREMENT...\nBON DÉBARA [Luigi] !!";
  } else if (mouseX>=shopSlotPosXLeft && mouseX<=shopSlotPosXLeft+SHOP_SLOT &&
    mouseY>=shopSlotPosYBottom && mouseY<=shopSlotPosYBottom+SHOP_SLOT) { // Potion
    textSize(20);
    shopDialogue = "MA [S. Potion] SI ADORÉE, QUE\nFERAIS-JE SANS TOI? UNE GORGÉE\nET [Kabloom], TON TEMPS\nRESTANT AVANT [Hyperlink\nBlocked] AUGMENTE DE\n[60 secondes] !!";
  } else if (mouseX>=shopSlotPosXRight && mouseX<=shopSlotPosXRight+SHOP_SLOT &&
    mouseY>=shopSlotPosYBottom && mouseY<=shopSlotPosYBottom+SHOP_SLOT) { // Keygen
    textSize(20);
    shopDialogue = "[KeyGen] !!!!! MA POSSESSION LA\nPLUS PRÉCIEUSE ! OH, VAS-Y.\nACHÈTE LE ! TU NE VAS JAMAIS\nREGRETTER LE [Hyperlink Blocked]\nQUI VIENT AVEC !!";
  } else if (mouseX>=shopExitPosX && mouseX<=shopExitPosX+shopExitWidth &&
    mouseY>=shopExitPosY && mouseY<=shopExitPosY+shopExitHeight) { // Bouton quitter
    textSize(30);
    shopDialogue = "TU NE VEUX PAS\nAPPUYER SUR\n[Ce Bouton].";
  }

  // Speech Bubble
  fill(COL_SPEECH_BUBBLE);
  stroke(COL_SHOP_TOP_STROKE);
  rect(20, 10, width/7*4.5, topScreenHeight/5*4, 20);

  // Texte Speech Bubble
  fill(COL_BG);
  text(shopDialogue, 40, 40);

  // Couleurs pour les Item Slots
  fill(COL_SHOP_TOP_BG);
  strokeWeight(2);
  // Place les slots pour les items
  square(shopSlotPosXLeft, shopSlotPosYTop, SHOP_SLOT);
  square(shopSlotPosXRight, shopSlotPosYTop, SHOP_SLOT);
  square(shopSlotPosXLeft, shopSlotPosYBottom, SHOP_SLOT);
  square(shopSlotPosXRight, shopSlotPosYBottom, SHOP_SLOT);
  // Place les items dans les slots
  image(itemGlasses, shopSlotPosXLeft+SHOP_ITEM_OFFSET, shopSlotPosYTop+SHOP_ITEM_OFFSET, SHOP_ITEM, SHOP_ITEM);
  image(itemScarf, shopSlotPosXRight+SHOP_ITEM_OFFSET, shopSlotPosYTop+SHOP_ITEM_OFFSET, SHOP_ITEM, SHOP_ITEM);
  image(itemPotion, shopSlotPosXLeft+SHOP_ITEM_OFFSET, shopSlotPosYBottom+SHOP_ITEM_OFFSET, SHOP_ITEM, SHOP_ITEM);
  image(itemKeygen, shopSlotPosXRight+SHOP_ITEM_OFFSET, shopSlotPosYBottom+SHOP_ITEM_OFFSET, SHOP_ITEM, SHOP_ITEM);
  // Dessine le bouton quitter
  rect(shopExitPosX, shopExitPosY, shopExitWidth, shopExitHeight);
  fill(COL_SHOP_TOP_BG);
  textSize(30);
  textAlign(CENTER);
  fill(COL_BG);
  text("S'enfuir", width/2, shopExitPosY+(shopExitHeight/3*2));
  // Dessine les prix
  textSize(24);
  text(itemGlassesPrice, shopSlotPosXLeft+SHOP_SLOT/2, shopSlotPosYTop+SHOP_SLOT);
  text(itemScarfPrice, shopSlotPosXRight+SHOP_SLOT/2, shopSlotPosYTop+SHOP_SLOT);
  text(itemPotionPrice, shopSlotPosXLeft+SHOP_SLOT/2, shopSlotPosYBottom+SHOP_SLOT);
  text(itemKeygenPrice, shopSlotPosXRight+SHOP_SLOT/2, shopSlotPosYBottom+SHOP_SLOT);
  // Montre le Nombre d'argent du joueur
  textAlign(LEFT);
  textSize(30);
  text("M: "+kromerAmount, width/10, topScreenHeight);
  hasSeenShop = true; // affiche l'argent hors du shop, ne se reset jamais
  noStroke();
}

// Quand t'achète un objet dans le shop --------------------
void purchaseItem(int itemIndex) {
  if (itemIndex == 0 && kromerAmount >= itemGlassesPrice) { // Glasses
    // Le but des lunettes est d'augmenter la taille de la cible
    kromerAmount -= itemGlassesPrice;
    targetSizeUp+=3;
    shopKeeper = loadImage("npc_shop_success.png");
  } else if (itemIndex == 1 && kromerAmount >= itemScarfPrice) { // Scarf
    // Le but de l'écharpe est de reset les chances de croiser Luigi
    kromerAmount -= itemScarfPrice;
    luigiChance=0;
    shopKeeper = loadImage("npc_shop_success.png");
  } else if (itemIndex == 2 && kromerAmount >= itemPotionPrice) { // Potion
    // Le but de la potion est d'augmenter le temps du joueur
    kromerAmount -= itemPotionPrice;
    timeLeft+=60;
    shopKeeper = loadImage("npc_shop_success.png");
  } else if (itemIndex == 3 && kromerAmount >= itemKeygenPrice) { // Keygen
    // Le but de Keygen est de surprendre le user avec un crash
    kromerAmount -= itemKeygenPrice;
    isKeygenGot = true;
    luigiChance = 100;
    targetSizeUp = 20;
    searchMario = loadImage("char_spe_mike.png");
    searchLuigi = loadImage("char_spe_spamton_search.png");
    searchYoshi = loadImage("char_spe_tenna.png");
    searchWario = loadImage("char_spe_queen.png");
    posterLuigi = loadImage("char_spe_spamton_close.png");
    shopKeeper = loadImage("npc_shop_success.png");
  } else { // Si les fonds ne sont pas assez pour un achat
    shopKeeper = loadImage("npc_shop_poor.png");
  }
}

// Quand Keygen est acheté --------------------
void activateKeygen() {
  // Met un titre aléatoire de gibberish
  int randomTitle = floor(random(4));
  if (randomTitle == 0) {
    windowTitle("ASDiohs0-eir92UJ1987lms;dfj90u3fnaf208OIDSNF");
  } else if (randomTitle == 1) {
    windowTitle("1O4HIdiosfgé902J3SALEMAN0ionadsIUàSFA09u1997");
  } else if (randomTitle == 2) {
    windowTitle("809NkohO.Rrng90PapyRuSDAkè83fhmKNIghTgOPM3oLte");
  } else {
    windowTitle("gjpo39KLM1kU3iojs23IOJHmikudfIOAI089àHBEaMàÈas");
  }
  deathTime = timer(deathTime); // Départ le timer de la fin
  if (deathTime<0.2) { // Reproduit l'écran blanc d'un crash avant le vrai
    windowResize(floor(random(displayWidth)), floor(random(displayHeight)));
    windowMove(floor(random(displayWidth-width)), floor(random(displayHeight-height)));
    fill(255, 255, 255, 35);
    rect(0, 0, width, height);
  }
  if (deathTime<0.1) { // Ré-adjuste la fenêtre pour être visible durant le crash
    windowResize(900, 600);
    windowMove((displayWidth/2)-(width/2), (displayHeight/2)-(height/2));
  }
  if (deathTime<0) { // vrai Crash
    PImage deathScreen = loadImage("adsiahbiduabuiwdbhn.gif");
    image(deathScreen, 0, 0, deathScreen.width, deathScreen.height);
  }
}
