/* Hello, tout ce qu'on a vu à présent est ici avec une expliquation et un exemple.
 * Pour naviguer optimalement ce fichier, utilisez CRTL+F(Win) ou CMD+F(Mac).
 * Good Luck avec le quiz.
*/
/*
// FORMES --------------------
// Ces formes sont dessinées à partir du haut à gauche
rect(x, y, width, height);
square(x, y, size);

// Ces formes sont dessinées à partir du centre
ellipse(x, y, width, height);
circle(x, y, size);

// Chaque vertexs de ces formes sont manuellement choisies
point(x, y); // Dessine un point, utiliser stroke() pour colorer
line(x1, y1, x2, y2); // Fait une line, utiliser stroke() pour colorer
triangle(x1, y1, x2, y2, x3, y3); // forme à 3 côtés
quad(x1, y1, x2, y2, x3, y3, x4, y4); // forme à 4 côtés

// Permet de faire des formes personnalisées 
beginShape(); // Dessine et connecte toutes les vertexs entre beginShape et endShape.
vertex(x, y); // Coordonnées des points qui seront connectés
endShape(CLOSE); // Ferme la forme entre beginShape() et endShape(CLOSE);

// Arc
// Start et Stop sont les angles, les PI ou radians(90) peuvent être utilisés
arc(x, y, width, height, start, stop);

// Taille de la fenêtre
size(width, height);

// MODIFICATION DE FORMES --------------------
// Modes de point d'origine
ellipseMode(CORNER); // Modifie d'où les ellipses sont dessinées à partir de
ellipseMode(CENTER);

rectMode(CORNER); // Modifie d'où les rectangles sont dessinés à partir de
rectMode(CENTER);

// TYPES DE VARIABLES --------------------
// Comment définir différent types de variables et leur nommenclature préférable
// Nommenclature camelCase
int nomInt = 2; // int veut dire un nombre entier, pas de virgule.
float nomFloat = 2.5; // float veut dire un nombre non-entier, avec une virgule
char nomChar = 'A'; // char veut dire caractère. Peut seulement en contenir 1.
String nomString = "phrase blah blah" // string veut dire série de caractères
color nomColor = color(255, 0, 10, 255); // color(Rouge, Vert, Bleu, Alpha)

// Nommenclature unique
// retourne la valeur true ou false. Typiquement nommée is+condition.
boolean isVariableName = true;

// Est une variable constante, la valeur ne changera pas plus tard dans le code.
// En majuscule avec des underscores pour indiquer que c'est une constante
final int MA_VARIABLE = 2;

// COULEURS --------------------
// Fill
fill(r, g, b, a) // ou fill(brightness); // Rempli les formes de la couleur
noFill(); // fait que les formes n'auront pas de couleur intérieur
background(r, g, b, a); // ou background(brightness);//Met la couleur d'arrière-plan

// Stroke
stroke(r, g, b, a); // ou stroke(brightness); Détermine la couleur
noStroke(); // Enlève le contour
strokeWeight(width); // Détermine l'épaisseur du contour en pixel
strokeCap(SQUARE); strokeCap(ROUND); // Détermine si les coins sont arrondis

// lerpColor
// Choisi une couleur entre 2 couleurs.
// Le progress est entre 0 et 1. 0 = color1, 1 = color2. 0.5 serait entre les 2.
color maVariable = lerpColor(color1, color2, progress);

// IF --------------------
// Vérifie si la condition est vraie, si oui, exécute le code, sinon fait rien
// Si le premier if est vrai, else if et else ne vont pas être exécuter.
// Dès que la condition d'un des if est vrai, tout ceux qui suivent seront ignorés
if (a == 3) {
  println("a égale 3");
} else if (a > 3) {
  println("a est plus grand que 3");
} else {
  println("a est plus petit que 3");
}

// CONDITIONS IF -------------------- 
// == vérifie l'égalité entre 2 valeurs. EX: if (maVariable == 1)
// && ajoute une condition supplémentaire. EX: if (maVariable == 1 && maVariable != 1)
// || vérifie si une des 2 conditions sont vraies. EX: if (a == 1 || a == 2)
// ! veut dire l'opposé. EX: if (!isBool)
// != veut dire n'égale pas. EX if (a != 2)
// > < vérifie si c'est plus grand que. EX: if (a < 2) ou (a > 2)
// >= <= vérifie si c'est plus grand ou égal. EX: if (a >= 2) ou (a <= 2)

// OPERATIONS DE MATH --------------------
// Ajoute un nombre à la variable. même chose que maVar = maVar + un nombre;
// += EX où maVar=5: maVar += 10; maVar égale maintenant 15.

// Même choses, mais soustrait, multipli et divise
// -= // Soustrait
// *= // Multipli
// /= // Divise

// Incrémentation (pour les boucles)
// maVar++ // augmente la variable de 1

// Décrémentation (pour les boucles)
// maVar-- // soustrait la variable de 1

// Ré-attribution de valeurs
// map(value, fromMin, fromMax, toMin, toMax);
float maVar = map(mouseX, 0, width, 100, 300);

// Met un minimum et un maximum possible
// constrain(value, min, max);
float maVar = constrain(mouseX, 100, 300);

// TRACKING DE LA SOURIS --------------------
// Contient la valeur des coordonnées X et Y de la position de la souris
mouseX
mouseY

// Contient la valeur des coordonnées X et Y de la souris de la frame précédente
// Bon pour détecter la vitesse de la souris
pmouseX
pmouseY
// Exemple d'utilisation
float diffX = abs(mouseX - pmouseX); // abs() donne la valeur absolue d'un calcul
strokeWeight(diffX); // Plus la souris va vite en horizontal, plus le trait est épais
line(pmouseX, pmouseY, mouseX, mouseY); // Dessine un trait qui suit la souris

// TOUCHE DE CLAVIER --------------------
// Détecte si une touche est appuyée
keyPressed

// Donne la touche la plus récemment appuyée sous type de caractère (char)
key

// Donne la touche spéciale la plus récemment appuyé
// Exemple de valeurs possibles: LEFT RIGHT UP DOWN SHIFT ALT CONTROL etc...
keyCode

// Exemple d'utilisation
if (keyPressed) { // check si une touche est appuyée
  if (key == 'a' || key == 'A') { // check si A est appuyé, pas oublié les ' '
    println("TOUCHE 'A' APPUYÉE");
  } else if (keyCode == LEFT) { // check si la flèche gauche est appuyé
    println("FLÈCHE GAUCHE SUR LE CLAVIER APPUYÉ");
  } else { // si une touche autre que A est appuyée
    println("TOUCHE APPUYÉE QUI N'EST PAS 'A' ");
  }
} else { // Si aucune touche est appuyée
  println("AUCUNE TOUCHE APPUYÉE");
}

// Détecte si la souris est appuyée
if (mousePressed) {
  println("SOURIS APPUYÉE");
} else {
  println("SOURIS PAS APPUYÉE");
}



// BOUCLE FOR --------------------
// Défini une variable qui changera avec chaque itération de la boucle jusqu'à tant
// que la condition mise soit vraie.
// Première section: initiation de la variable unique à la boucle
// Deuxième section: condition à complèter pour finir la boucle
// Troisième section: changement de la valeur de la variable
for (int i = 20; i < 200; i += 10) {
  line(100, i, 300, i);
}

// TRANSFORM --------------------
// Change le point d'origine de la forme, le point dont les modifications sont faites
translate(x, y);

// Applique une rotation à la forme. Accepte les PI et radians(90)
rotate(radians(45));

// Manipule la taille d'un élément, incluant l'épaisseur du contour
scale(0.5);

// Permet d'encadrer les modifications entre quelques lignes, n'affectant pas le reste
pushMatrix(); // Ouverture de l'encadrement
translate(10, 10);
popMatrix(); // Fermeture de l'encadrement

// COLLISION --------------------
// Collision avec un cercle
float circleX = 10; // Coordonnées et taille du cercle de collision
float circleY = 10;
float circleRadius = 20;
circle(circleX, circleY, circleRadius*2); // Placement du cercle

// dist(x1, y1, x2, y2) permet de trouver la distance en pixel entre 2 coordonnées
float distance = dist(mouseX, mouseY, circleX, circleY);

if (distance <= circleRadius) { // Check si la souris est dans le cercle
  println("COLLISION AVEC CERCLE");
} else {
  println("PAS DE COLLISION");
}

// Collision avec un rectangle
float rectX = 10; // Coordonnées et taille du rectangle
float rectY = 20;
rectWidth = 30;
rectHeight = 40;

rect(rectX, rectY, rectWidth, rectHeight); // Placement du rectangle

if (rectX <= mouseX && // Si la sourisX est plus grand que 10 (rectX)
    mouseX <= (rectX + rectWidth) // Si la sourisX est plus petit que 40 (x+width)
    rectY <= mouseY && // Si la sourisY est plus grand que 20 (rectY)
    mouseY <= (rectY + rectHeight)){// si la sourisY est plus petit que 60 (y+height)
// Essentiellement, on viens de check si la coordonné de la souris est dans le rect
  println("COLLISION AVEC RECTANGLE");
} else {
  println("PAS DE COLLISION");
}


*/
