/*
 * Titre: EDM1700 Exercice 2: "Cadavre Exquis"
 * Autrice de la tête: Léa Gouanvic-Franco
 * Auteur du corps: Alexandre Gervais
 * Version: 1.0
 * Instructions: Appuyez sur le bouton Run.
 * Description du projet: Une tête et un corps, chacun réalisés par 2 différentes
 * personnes qui ne savent pas ce que l'autre a fait.
 */
 
size(400, 600);
background(40);

//tete
noStroke();
fill(210,0,50);
ellipse(200 ,102 ,160 , 200);

//eclair milieu de tete
fill(0,200,220);
noStroke();
quad(200, 27, 200, 75, 195, 51, 205, 51);

//arriere yeux
fill(190,0,50);
quad(145, 70, 191, 80, 178, 105, 130, 105);
quad(209, 80, 254, 70, 269, 105, 222, 105);

//yeux
fill(0,200,220);
quad(155, 80, 181, 80, 168, 95, 140, 95);
quad(219, 80, 244, 80, 259, 95, 232, 95);

//pupilles
fill(0,0,0);
quad(160, 80, 174, 87, 159, 95, 149, 87);
quad(240, 95, 251, 87, 241, 80, 227, 87); 

//nez
noStroke();
fill(190,0,50);
triangle(200, 91, 214, 128, 186, 128);
fill(0,0,0);
triangle(200, 101, 205, 124, 195, 124);

//bouche
noStroke();
fill(0,200,220);
quad(200, 145, 216, 154, 200, 163, 184, 154);  
quad(232, 145, 248, 154, 232, 163, 216, 154);  
quad(168, 145, 184, 154, 168, 163, 152, 154); 

//cousure sur bouche
fill(0,150,200);
quad(200, 155, 216, 144, 200, 163, 184, 144);  
quad(232, 155, 248, 144, 232, 163, 216, 144); 
quad(168, 155, 184, 144, 168, 163, 152, 144); 

//cornes
noStroke();
fill(210,0,50);
triangle(240, 20, 290, 15, 245, 30);  
triangle(160, 20, 110, 15, 155, 30);  
rect(240, 20, 25, 25);
rect(135, 20, 25, 25); 

//ligne sur bouche
stroke(0,150,200); 
strokeWeight(2);
strokeCap(ROUND);
line(164, 154, 236, 154);

//sourcil gauche
stroke(0,0,0);
strokeWeight(4);
strokeCap(ROUND);
line(150, 50, 180, 70);


//sourcil droit
stroke(0,0,0);
strokeWeight(4);
strokeCap(ROUND);
line(250, 50, 220, 70);

//cou
noStroke();
rect(182,190,35,20); 

//masque
fill(0);
rect(100,0,200,200);

// -------------------------------------------
//   D É B U T   C O D E   A L E X A N D R E
// -------------------------------------------
// Instructions: 1 boucle for repeat min 5x. Width et Height use min 1x
// Création des variables
final color COL_SHIRT = color(173);
final color COL_SKIN = color(210,0,50);
final color COL_SKIRT = color(69,74,77);
final color COL_ACCENT = color(142, 208, 208);

// Skirt
fill(COL_SKIRT);
noStroke();
quad(140, 380, 260, 380, 280, 440, 120, 440);
fill(COL_ACCENT);
quad(280, 440, 120, 440, 120, 447, 280, 447);
for(float x = 125; x<295; x+=25){
  float y = 390;
  if (x>=200){
    fill(COL_SKIRT);
    quad(x-(width/20), y, x-(width/10), y, x-(width/20), y+(height/10), x, y+(height/10));
    fill(COL_ACCENT);
    quad(x-(width/20), y+(height/10), x, y+(height/10), x, y+(height/10)+7, x-(width/20), y+(height/10)+7);
  } else {
    fill(COL_SKIRT);
    quad(x+(width/20), y, x+(width/10), y, x+(width/20), y+(height/10), x, y+(height/10));
    fill(COL_ACCENT);
    quad(x+(width/20), y+(height/10), x, y+(height/10), x, y+(height/10)+7, x+(width/20), y+(height/10)+7);
  }
}

// Shirt
fill(COL_SHIRT);
stroke(COL_ACCENT);
quad(175, 205, 225, 205, 260, 265, 140, 265);
noStroke();
quad(257, 262, 143, 262, 155, 320, 245, 320);

// Shirt Bottom Colored
stroke(COL_ACCENT);
beginShape();
vertex(260, 380);
vertex(220, 400);
vertex(200, 370);
vertex(180, 400);
vertex(140, 380);
vertex(200, 360);
endShape(CLOSE);

// Shirt Bottom
noStroke();
beginShape();
vertex(155, 320);
vertex(245, 320);
vertex(260, 380);
vertex(220, 400);
vertex(200, 370);
vertex(180, 400);
vertex(140, 380);
endShape(CLOSE);

// Tie
fill(COL_ACCENT);
quad(195, 218, 205, 218, 207, 228, 193, 228);
quad(205, 228, 195, 228, 185, 380, 215, 380);
triangle(185, 380, 215, 380, 200, 400);
fill(COL_SKIRT);
rect(186, 350, 15, 8);
rect(186, 359, 15, 8);

// Shirt Collar
fill(COL_SHIRT);
stroke(COL_ACCENT);
strokeWeight(2);
beginShape();
vertex(170,200);
vertex(200,205);
vertex(230,200);
vertex(235, 210);
vertex(220, 230);
vertex(200, 210);
vertex(180, 230);
vertex(165, 210);
endShape(CLOSE);
