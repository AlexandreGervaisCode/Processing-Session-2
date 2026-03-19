class Enemy {
  // Stats de combat
  float atk, def, hp, maxHp = 1;
  // Placement de l'enemie
  float posX,posY = width/4*3;
  float scaleX, scaleY = 100;
  // Visualisation de l'enemie
  PImage sprite = loadImage("mob_placeholder.png");
  
  // --------------------
  // CONSTRUCTOR
  // --------------------
  Enemy (float a, float d, float h, float x, float y, float sx, float sy, String spriteLink) {
    atk = a;
    def = d;
    maxHp = h;
    hp = maxHp;
    posX = x;
    posY = y;
    scaleX = sx;
    scaleY = sy;
    sprite = loadImage(spriteLink);
  }
  
  // Affiche l'enemie
  void display() {
    image(sprite, posX, posY, scaleX, scaleY);
  }
  
  // Si l'ennemie est endommagé
  void hurt(float damage) {
    hp -= damage;
    if (isDead()) {
      deathAnim();
    }
  }
  void hurt() {
    hp -= 1;
    if (isDead()) {
      deathAnim();
    }
  }
  
  // Check si l'enemi est mort
  boolean isDead() {
    return hp<=0;
  }
  // Séquence de mort
  void deathAnim() {
    // deathAnim here
  }
  
  // Retourne les stats
  float getAtk() {
    return atk;
  }
  float getDef() {
    return def;
  }
  float getHP() {
    return hp;
  }
  float getMaxHP() {
    return maxHp;
  }
}
