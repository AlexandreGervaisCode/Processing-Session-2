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
// Note : Le personnage reproduit avec le concept de monstre en tête est Hatsune Miku "monster-fied"

// Création des variables
final color COL_SHIRT = color(173);
final color COL_SKIN = color(210,0,50);
final color COL_CLOTHES = color(69,74,77);
final color COL_ACCENT = color(142, 208, 208);
final color COL_TATTOO = color(234, 73, 88);
final color COL_DETAIL = color(232, 234, 123);

// Left Leg
fill(COL_SKIN);
noStroke();
quad(130, 420, 195, 420, 190, 500, 132, 500);
// Thights
fill(COL_CLOTHES);
quad(190, 500, 132, 500, 133, 600, 188, 600);
strokeWeight(5);
stroke(COL_ACCENT);
line(190, 500, 132, 500);

// Right Leg
fill(COL_SKIN);
noStroke();
quad(270, 420, 205, 420, 210, 500, 268, 500);
// Thights
fill(COL_CLOTHES);
quad(210, 500, 268, 500, 267, 600, 212, 600);
stroke(COL_ACCENT);
line(210, 500, 268, 500);

// Skirt
fill(COL_CLOTHES);
noStroke();
quad(140, 380, 260, 380, 280, 440, 120, 440);
fill(COL_ACCENT);
quad(280, 440, 120, 440, 120, 447, 280, 447);
for(float x = 125; x<300; x+=25){
  float y = 386;
  fill(COL_CLOTHES);                   
  if (x>=200){
    quad(x-(width/20), y, x-(width/10), y, x-(width/20), y+(height/10), x, y+(height/10));
    fill(COL_ACCENT);
    quad(x-(width/20), y+(height/10), x, y+(height/10), x, y+(height/10)+7, x-(width/20), y+(height/10)+7);
  } else {
    quad(x+(width/20), y, x+(width/10), y, x+(width/20), y+(height/10), x, y+(height/10));
    fill(COL_ACCENT);
    quad(x+(width/20), y+(height/10), x, y+(height/10), x, y+(height/10)+7, x+(width/20), y+(height/10)+7);
  }
}

// Belt Thing
noFill();
stroke(COL_ACCENT);
beginShape();
vertex(225, 400);
vertex(228, 410);
vertex(233, 425);
vertex(240, 440);
vertex(250, 450);
vertex(254, 452);
vertex(258, 452);
vertex(260, 450);
vertex(265, 440);
vertex(268, 430);
vertex(270, 415);
vertex(268, 400);
vertex(263, 382);
endShape();

// Left Arm
noStroke();
fill(COL_SKIN);
rect(150, 208, 40, 30);
circle(150, 235, 55);
quad(123, 230, 145, 240, 120, 320, 90, 320);
// Arm Sleeve Color
fill(COL_CLOTHES);
strokeWeight(4);
stroke(COL_ACCENT);
beginShape();
vertex(90, 319);
vertex(120, 319);
vertex(80, 380);
vertex(100, 462);
vertex(20, 452);
vertex(80, 380);
endShape(CLOSE);
// Arm Sleeve
noStroke();
quad(120, 320, 90, 320, 20, 450, 100, 460);

// Right Arm
fill(COL_SKIN);
rect(210, 208, 40, 30);
circle(250, 235, 55);
quad(277, 230, 255, 240, 280, 320, 310, 320);
// Arm Sleeve Color
fill(COL_CLOTHES);
stroke(COL_ACCENT);
beginShape();
vertex(310, 319);
vertex(280, 319);
vertex(320, 380);
vertex(300, 462);
vertex(380, 452);
vertex(320, 380);
endShape(CLOSE);
// Arm Sleeve
noStroke();
fill(COL_CLOTHES);
quad(280, 320, 310, 320, 380, 450, 300, 460);

// Tattoo
stroke(COL_TATTOO);
strokeWeight(2);
noFill();
// le 0
beginShape();
vertex(258,225);
vertex(256,227);
vertex(253,232);
vertex(258,239);
vertex(260,241);
vertex(262,241);
vertex(264,232);
vertex(262,227);
endShape(CLOSE);
// le 1
line(265,230,270,225);
line(270,225,274,240);
// Ligne du bas
line(258, 244, 278, 242);
// Ligne du milieu du 0
stroke(COL_SKIN);
line(258,225,262,241);

// Shirt
fill(COL_SHIRT);
stroke(COL_ACCENT);
strokeWeight(4);
quad(175, 205, 225, 205, 260, 265, 140, 265);
noStroke();
quad(257, 262, 143, 262, 155, 320, 245, 320);
fill(COL_DETAIL);
rect(212, 248, 24, 9);
// Shirt Bottom Colored
stroke(COL_ACCENT);
noFill();
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
fill(COL_SHIRT);
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
fill(COL_CLOTHES);
rect(186, 350, 15, 8);
rect(186, 359, 15, 8);

// Shirt Collar Colored
stroke(COL_ACCENT);
strokeWeight(3);
beginShape();
vertex(235, 210);
vertex(220, 230);
vertex(200, 210);
vertex(180, 230);
vertex(165, 210);
vertex(200, 205);
endShape(CLOSE);
// Shirt Collar
fill(COL_SHIRT);
noStroke();
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
