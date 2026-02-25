void setup(){
  size(800, 800);
}

void draw(){
  background(10);
  mainHouse(width/2, height/2, 200, 200);
}

void mainHouse(float x, float y, float w, float h) {
  noStroke();
  rectMode(CENTER);
  // wall
  fill(#FAD890); // beige walls
  rect(x, y, w, h);
  
  // roof
  fill(#F73C3C); // red mush
  ellipse(x, y*0.7, w*2, h*1.5);
  
  fill(#EDEDED); // white mush
  ellipse(x, y*0.7, w*1.25, h*1.25);
  
  // chimney
  fill(#BCBCBC); // grey chimney
  rect(x*1.25, y*0.35, w/4, h*0.5);
  rectMode(CORNER);
  stroke(#000000);
}
