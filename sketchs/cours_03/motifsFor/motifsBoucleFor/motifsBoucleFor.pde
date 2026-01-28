// Environnement SetUp
size(800,800);
background(32);
noStroke();

// Initiation des variables
final int RED_COLOR = 255;
int saturationGreen = 0;
int saturationBlue = 0;

// Boucle For pour couvrir verticalement
for(float y=0; y<800; y+= 80){
  // Attribution du montant aléatoire de vert et bleu dans les étoiles
  float randomGreen = random(0, 255);
  float randomBlue = random(0, 255);
  floor(randomGreen);
  floor(randomBlue);
  saturationGreen = int(randomGreen);
  saturationBlue = int(randomBlue);
  // Boucle For pour couvrir horizontalement
  for(float x=0; x<800; x+= 80){
    // Attribue la couleur
    fill(RED_COLOR, saturationGreen-=10, saturationBlue-=5);
    
    // Forme de l'étoile
    beginShape();
    vertex(40+x,0+y);
    vertex(55+x, 30+y);
    vertex(80+x, 30+y);
    vertex(60+x, 50+y);
    vertex(70+x, 80+y);
    vertex(40+x, 60+y);
    vertex(10+x, 80+y);
    vertex(20+x, 50+y);
    vertex(0+x, 30+y);
    vertex(25+x, 30+y);
    endShape(CLOSE);
  }
}
