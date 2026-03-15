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
final color COL_BG = color(0);
final color COL_TEXT = color(255, 231, 55);

// Controle du jeu --------------------
boolean isSearching; // Permet de détecter si le jeu est en cours
boolean isGameOver; // Permet de détecter si y'a un Game Over
boolean isInTransition; // Permet de détecter si le joueur est en transition
int wantedCharIndex; // Permet de savoir quel perso doit être trouvé
float luigiChance = 0; // calcule les chances que Luigi doit être trouvé
float timeLeft; // Temps restant avant que le jeu fini
float transitionTime; // Temps de transition entre les rounds
int nextTransitionHiddenValue; // Permet d'avoir des events secrets
int kromerAmount = 0; // Montant d'argent
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
  // Définit les extrêmités de placement de personnages
  charMinPosX = OFFSET;
  charMaxPosX = width-OFFSET-(SEARCH_SIZE);
  charMinPosY = height/3+OFFSET+(SEARCH_SIZE/2);
  charMaxPosY = height-OFFSET-(SEARCH_SIZE);
  // Commence le timer à 1 minute
  timeLeft = 30;
  topScreenHeight = height/3;
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
  if (isInTransition) {
    transitionTime = timer(transitionTime);
    if (transitionTime>0) {
      fill(COL_TEXT);
      rect(0, 0, width, height);
      createCharacter(targetPosX, targetPosY, targetChar);
    } else {
      isInTransition = !isInTransition;
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
      isSearching = false;
    } else if (mousePressed) {
      timeLeft -= 10;
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
