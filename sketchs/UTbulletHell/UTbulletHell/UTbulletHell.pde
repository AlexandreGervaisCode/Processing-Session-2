/*
 * Titre: Projet personel: "Undertale Bullet Hell"
 * Auteur: Alexandre Gervais
 * Version: 1.0
 * Instructions: Esquiver les attaques avec WASD. Surviver.
 * Description du projet: WO O O O O, STORY OF UNDERTALE
 */

// Color Variables
final color COL_BG = color(0);
final color COL_SOUL = color(255,0,0);
final color COL_BORDER = color(0,192,0);
final color COL_BULLET = color(255);
final color COL_MENU = color(255,127,39);
final color COL_HP_EMPTY = color(115,0,2);

// Values variables
final float BOX_SIZE = 400;
int health;
float posX;
float posY;
boolean dUp = false;
boolean dDown = false;
boolean dLeft = false;
boolean dRight = false;
boolean isDebugOn = false;
float soulSpeed = 4;
float soulHitboxRadius = 15;
float attackRadius = 20;
float soulGradientPercent = 0;

boolean isGameOver = false;

// Invincibility Frames
boolean isInvincible = false;
int maxInvincibilityFrames = 120;
int invincibilityFramesLeft = maxInvincibilityFrames;

void setup() {
  size(1000,750);
  posX = width/2;
  posY = height/2;
  health = 20;
}

void draw() { 
  background(COL_BG);
  color soulColor = lerpColor(COL_SOUL,COL_BG,soulGradientPercent);
  // Soul
  noStroke();
  fill(soulColor);
  pushMatrix();
  translate(posX,posY);
  circle(-7,-5,20);
  circle(7,-5,20);
  popMatrix();
  pushMatrix();
  translate(posX,posY+5);
  rectMode(CENTER);
  rotate(radians(45));
  square(0,0, 15);
  popMatrix();
  
  // Debug things
  if (isDebugOn) {
    // Hitbox
    noFill();
    stroke(COL_BULLET);
    strokeWeight(1);
    circle(posX,posY,soulHitboxRadius*2);
    noStroke();
    
    // Bullet Spawn
    fill(COL_BULLET);
    circle(width/3,height/3,attackRadius*2);
    float testDist = dist(posX,posY,width/3,height/3);
    if (testDist<=soulHitboxRadius*2){
      damage();
    }
    
    // Info Display
    fill(COL_BULLET);
    textAlign(LEFT);
    textSize(20);
    text("HP: "+str(health), 10, 20);
    text("X: "+str(posX), 10, 40);
    text("Y: "+str(posY), 10, 60);
    text("Key: "+str(key), 10, 80);
    text("Invinc Frames: "+str(invincibilityFramesLeft), 10, 100);
    text("is Invincible: "+str(isInvincible), 10, 120);
  }
  
  if (keyPressed) {
    if ((dUp && dLeft) || (dUp&&dRight) || (dDown&&dLeft) || (dDown&&dRight)) {
      soulSpeed = 4/sqrt(2);
    } else {
      soulSpeed = 4;
    }
    if (dUp  && posY>(height-BOX_SIZE)/2+20) {
      posY-=soulSpeed;
    }
    if (dDown && posY<(height-BOX_SIZE)*1.5+30) {
      posY+=soulSpeed;
    }
    if (dLeft && posX>(width-BOX_SIZE)/2+20) {
      posX-=soulSpeed;
    }
    if (dRight && posX<(width-BOX_SIZE)+80) {
      posX+=soulSpeed;
    }
  }
  
  
  
  // Bounding Box
  rectMode(CENTER);
  noFill();
  strokeWeight(8);
  stroke(COL_BORDER);
  square(width/2,height/2,BOX_SIZE);
  
  // Health Bar
  rectMode(CORNER);
  fill(COL_HP_EMPTY);
  noStroke();
  rect(width/2-150,100,300,20);
  fill(COL_MENU);
  rect(width/2-150,100,health*15,20);
  
  // Invincibility Check
  if (isInvincible){
      if (invincibilityFramesLeft>=0){
        isInvincible=true;
        invincibilityFramesLeft-=1;
        soulGradientPercent = random(0,1);
      } else{
        isInvincible=false;
        invincibilityFramesLeft=maxInvincibilityFrames;
        soulGradientPercent=0;
      }
    }
  
  // Game Over
  if (health<=0) {
    isGameOver = true;
  }
  if (isGameOver) {
    fill(COL_BG);
    rect(0,0,width,height);
    fill(COL_BULLET);
    textAlign(CENTER);
    text("GAME OVER",width/2,height/3);
    text("PRESS R TO RESTART",width/2,height/2);
  }
}

void keyPressed() {
  // Detects Movement inputs
  if (key=='w' || key=='W'){
      dUp=true;
  }
  if (key=='s' || key=='S'){
      dDown=true;
  }
  if (key=='a' || key=='A'){
    dLeft=true;
  }
  if (key=='d' || key=='D'){
    dRight=true;
  }
  // Activates Debug Mode
  if (key=='p' || key=='P'){
      isDebugOn=!isDebugOn;
  }
  // Restarts if Game Over
  if ((key=='r' || key=='R') && isGameOver){
    health=20;
    isGameOver=false;
    posX=width/2;
    posY=height/2;
  }
}

void keyReleased() {
  // Releases movement inputs
  if (key=='w' || key=='W'){
      dUp=false;
  }
  if (key=='s' || key=='S'){
    dDown=false;
  }
  if (key=='a' || key=='A'){
    dLeft=false;
  }
  if (key=='d' || key=='D'){
    dRight=false;
  }
}

void damage() {
  if (!isGameOver){
    if (!isInvincible){
      health-=1;
      isInvincible=true;
    }
  }
}
