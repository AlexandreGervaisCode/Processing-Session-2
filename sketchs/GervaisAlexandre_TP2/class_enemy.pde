class Enemy {
  int ID = 0;
  // Stats de combat
  int atk, hp, maxHp = 1;
  // Placement de l'enemie
  float posX,posY = width/4*3;
  float scaleX, scaleY = 100;
  // Visualisation de l'enemie
  PImage sprite = loadImage("DEBUG_mob.png");
  // Collection de Data sur l'ennemie
  JSONArray enemies = loadJSONArray("./json/enemies.json");
  JSONObject selectedEnemy = enemies.getJSONObject(ID);
  
  // Timer pour l'animation de mort en frames (30fps)
  int deathAnimTime = 2*30;
  
  // --------------------
  // CONSTRUCTOR
  // --------------------
  Enemy (int mobID) {
    // Juste avec l'ID, tout ce fait correctement attribuer selon le contenu JSON
    ID = mobID;
    selectedEnemy = enemies.getJSONObject(ID);
    atk = selectedEnemy.getInt("attack");
    maxHp = selectedEnemy.getInt("maxHp");
    hp = maxHp;
    scaleX = selectedEnemy.getFloat("scaleX");
    scaleY = selectedEnemy.getFloat("scaleY");
    sprite = loadImage(selectedEnemy.getString("sprite"));
  }
  
  // Affiche l'enemie
  void display() {
    image(sprite, posX, posY, scaleX, scaleY);
  }
  
  // Si l'ennemie est endommagé
  void hurt(Player playerAttack) {
    hp -= playerAttack.getAtk();
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
    if (scaleX > 0) {
      scaleX -= scaleX/deathAnimTime;
    }
    if (scaleY > 0) {
      scaleY -= scaleY/deathAnimTime;
    }
  }
  
  // Retourne les stats
  float getAtk() {
    return atk;
  }
  float getHP() {
    return hp;
  }
  float getMaxHP() {
    return maxHp;
  }
  int getID() {
    return ID;
  }
}
