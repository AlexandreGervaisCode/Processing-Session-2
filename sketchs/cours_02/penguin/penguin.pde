size(800, 800);
background(100, 150, 230);

int black = 20;
int white = 230;
color orange = color(200, 120, 50);
noStroke();

// Iceberg
fill(white);
rect(150, 580, 500, 190);
// Bottom Iceberg
triangle(150, 770, 180, 820, 210, 770);
triangle(270, 770, 330, 810, 350, 770);
triangle(420, 770, 450, 805, 520, 770);
triangle(650, 770, 610, 810, 550, 770);

// Les formes noirs du penguin
fill(black);

// tête
ellipse(width/2, 200, 275, 250);

// ventre
ellipse(375, 425, 325, 400);
ellipse(425, 425, 325, 400);

// bras
ellipse(175, 325, 200, 75);
ellipse(625, 325, 200, 75);

//Blanc du pengouin
fill(white);
//tête
ellipse(400, 200, 225,  200);

// Ventre
ellipse(375, 425, 275,  350);
ellipse(425, 425, 275,  350);

// Triangle noir Tête
fill(black);
triangle(370, 100, 430, 100, 400, 145);

// pieds
fill(orange);
// pied gauche
ellipse(320, 620, 100, 50);
ellipse(291, 635, 35, 20);
ellipse(330, 640, 35, 20);

// pied droit
ellipse(480, 620, 100, 50);
ellipse(509, 635, 35, 20);
ellipse(470, 640, 35, 20);

// Bec
triangle(370, 200, 430, 200, 400, 260);

// Yeux
fill(black);
ellipse(350, 180, 50, 50);
ellipse(450, 180, 50, 50);

// blanc des yeux
fill(white);
ellipse(350, 185, 15, 15);
ellipse(450, 185, 15, 15);
