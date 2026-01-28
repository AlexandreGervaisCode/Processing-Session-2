/*
 * Titre: EDM1700 Exercice 1: "Cadavre Exquis"
 * Auteur de la tête: Alexandre Gervais
 * Auteur.trice du corps: [Prénom Nom]
 * Version: 1.0
 * Instructions: Appuyez sur le bouton Run.
 * Description du projet: Une tête et un corps, chacun réalisés par 2 différentes
 * personnes qui ne savent pas ce que l'autre a fait.
 */
 
 // Mettre la fenêtre à la taille demandé avec un arrière-plan foncé
size(400, 600);
background(61, 46, 41);

// Palette de couleur utilisé
final color COL_MAIN = color(255, 60, 60);
final color COL_MAIN_SHADING = color(255, 40, 40);
final color COL_WHITE = color(235);
final color COL_WHITE_SHADING = color(255);
final color COL_BLACK = color(15);


// Élément arrière-plan "eyeSocket"
noStroke();
fill(COL_BLACK);
ellipse(70, 55, 200, 140);
ellipse(330, 55, 200, 140);

// Élément arrière-plan "Yeux"
stroke(209, 113, 11);
strokeWeight(2);
fill(247, 238, 117);
circle(70, 50, 90);
circle(330, 50, 90);

// Élément arrière-plan "Pupille"
fill(COL_BLACK);
strokeWeight(1);
circle(75, 52, 15);
circle(325, 52, 15);

// Forme de la tête
noStroke();
fill(COL_MAIN);
ellipse(width/2, 90, 175, 175);
rect(112, 90, 175, 118);
triangle(115, 65, 115, 208, 105, 208);
triangle(285, 65, 295, 208, 285, 208);

// Épaules
fill(COL_MAIN);
rect(103, 180, 194, 28);
fill(COL_MAIN_SHADING);
rect(103, 178, 194, 4);

// Forme tête shading
fill(COL_MAIN_SHADING);
ellipse(width/2, 90, 150, 150);
rect(132, 130, 134, 78);

// Yeux
strokeWeight(4);
stroke(COL_BLACK);
fill(COL_WHITE);
circle(140, height/6, 86);
circle(260, height/6, 86);

// Yeux Shading
noStroke();
fill(COL_WHITE_SHADING);
circle(138, 99, 70);
circle(258, 99, 70);

// Pupilles
fill(COL_BLACK);
circle(122, 95, 20);
circle(235, 95, 20);

// Bouche
fill(COL_MAIN_SHADING);
quad(109, 148, 108, 158, 292, 158, 291, 148);
fill(COL_BLACK);
quad(108, 150, 107, 156, 293, 156, 292, 150);

// Canvas space pour la tête
fill(0);
rect(0, 0, 400, 200);
