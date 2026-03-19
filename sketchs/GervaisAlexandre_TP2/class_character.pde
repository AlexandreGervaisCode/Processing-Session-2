class Player {
  float atk, def, hp, maxHp = 1;
  int money = 0;
  float posX = width/4;
  float posY = height/3*2;
  float scaleX = 150;
  float scaleY = 150;
  PImage sprite = loadImage("pla_hero0.png");
  // --------------------
  // CONSTRUCTOR
  // --------------------
  Player (float a, float d, float h, int m, float sx, float sy, String spriteLink) {
    atk = a;
    def = d;
    maxHp = h;
    hp = maxHp;
    money = m;
    scaleX = sx;
    scaleY = sy;
    sprite = loadImage(spriteLink);
  }
  
  // Affiche le joueur
  void display() {
    image(sprite, posX, posY, scaleX, scaleY);
  }
  
  // Si le joueur est endommagé
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
  int getMoney() {
    return money;
  }
}
