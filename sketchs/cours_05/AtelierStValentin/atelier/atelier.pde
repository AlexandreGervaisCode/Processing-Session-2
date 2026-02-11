final color COL_RED = #FC0522;
final color COL_WHITE = #FFFFFF;
float posX = 400;
float posY = 400;


void setup(){
  size(800,800);
}

void draw(){
  // BG
  background(10);
  
  float gradientPoint = map(posY, 100, 700, 0, 1);
  color soulColor = lerpColor(COL_RED, COL_WHITE, gradientPoint);
  
  // Heart
  noStroke();
  fill(soulColor);
  pushMatrix();
  translate(posX,posY);
  circle(0,0,50);
  circle(30,0,50);
  popMatrix();
  pushMatrix();
  translate(posX+15,posY+22);
  rectMode(CENTER);
  rotate(radians(45));
  square(0,0, 40);
  popMatrix();
  
  //pushMatrix();
  if(keyPressed){
    if (keyCode == UP && posY>=150){
      posY-=5;
    } else if (keyCode == DOWN && posY<=625){
      posY+=5;
    } else if (keyCode == LEFT && posX>=150){
      posX-=5;
    } else if (keyCode == RIGHT && posX<=625){
      posX+=5;
    }
  }
  rectMode(CORNER);
  noFill();
  stroke(#00ff00);
  strokeWeight(6);
  square(100,100,600);
}
