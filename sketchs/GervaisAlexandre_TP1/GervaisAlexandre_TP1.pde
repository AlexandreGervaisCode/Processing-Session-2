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
int wantedCharIndex; // Permet de savoir quel perso doit être trouvé
float luigiChance; // calcule les chances que Luigi doit être trouvé
float othersChance; // calcule les chances qu'un des autres doit être trouvé
float timeLeft; // Temps restant avant que le jeu fini
int currentScore; // Pointage
final float OFFSET = 10; // Offset pour ne pas avoir les perso sur les coins
final int SEARCH_SIZE = 55; // Définit la taille des images à chercher
final int POSTER_SIZE = 150; // Définit la taille de l'image du poster
float charMinPosX; // Défini la posX minimum des search icons
float charMaxPosX; // Défini la posX maximale des search icons
float charMinPosY; // Défini la posY minimum des search icons
float charMaxPosY; // Défini la posY maximale des search icons
float targetPosX; // Garde en mémoire la posX de la cible
float targetPosY; // Garde en mémoire la posY de la cible
final float ERROR_MARGIN = 5; // Marge d'erreur permise
int minCharInstances = 20; // Controle combien de persos minimum affiché
int maxCharInstances = 50; // Controle combien de persos maximum affiché
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
  wantedFont = createFont("sm-64-ds-usa-font.otf", 50);
  // Définit les extrêmités de placement de personnages
  charMinPosX = OFFSET;
  charMaxPosX = width-OFFSET-(SEARCH_SIZE);
  charMinPosY = height/3+OFFSET+(SEARCH_SIZE/2);
  charMaxPosY = height-OFFSET-(SEARCH_SIZE);
}

void draw() {
  // Réalise ce code 1 seule fois par minigame round
  if (!isSearching) {
    background(COL_BG);
    wantedCharIndex = floor(random(0, 4));
    // Normalement, ceci serait fait avec un array, mais ceci devra faire.
    if (wantedCharIndex == 0) { // Si Mario est le perso à chercher
      posterChar = posterMario;
      targetChar = searchMario;
      wrongChar1 = searchLuigi;
      wrongChar2 = searchWario;
      wrongChar3 = searchYoshi;
      windowTitle("WANTED - MARIO");
    } else if (wantedCharIndex == 1) { // Si Luigi est le perso à chercher
      posterChar = posterLuigi;
      targetChar = searchLuigi;
      wrongChar1 = searchMario;
      wrongChar2 = searchWario;
      wrongChar3 = searchYoshi;
      windowTitle("WANTED - LUIGI");
    } else if (wantedCharIndex == 2) { // Si Wario est le perso à chercher
      posterChar = posterWario;
      targetChar = searchWario;
      wrongChar1 = searchLuigi;
      wrongChar2 = searchMario;
      wrongChar3 = searchYoshi;
      windowTitle("WANTED - WARIO");
    } else if (wantedCharIndex == 3) { // Si Yoshi est le perso à chercher
      posterChar = posterYoshi;
      targetChar = searchYoshi;
      wrongChar1 = searchLuigi;
      wrongChar2 = searchWario;
      wrongChar3 = searchMario;
      windowTitle("WANTED - YOSHI");
    }
    image(posterChar, width/2-(POSTER_SIZE/2), height/16, POSTER_SIZE, POSTER_SIZE);
    // Décide le nombre d'instances chaque mauvais perso vont apparaitres
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
    // Ce booléan permet de décider les positions aléatoires 1 seule fois
    isSearching = true;
    // fun thingy to play with
    windowMove(floor(random(displayWidth-width)), floor(random(displayHeight-height)));
  }
}

// Création des personnages --------------------
void createCharacter(float posX, float posY, PImage characterImg) {
  image(characterImg, posX, posY, SEARCH_SIZE, SEARCH_SIZE);
  if (characterImg == targetChar) {
    targetPosX = posX;
    targetPosY = posY;
  }
}

// Détection de réussite/échec ---------------------
void mousePressed() {
  if (isSearching) {
    if (mouseX>=targetPosX && mouseX<=targetPosX+SEARCH_SIZE &&
      mouseY>=targetPosY-ERROR_MARGIN && mouseY<=targetPosY+SEARCH_SIZE+ERROR_MARGIN) {
      println("yippee");
      isSearching = false;
    } else if (mousePressed) {
      println("oh no");
    }
  }
}
