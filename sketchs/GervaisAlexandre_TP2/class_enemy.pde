class Enemy {
  int ID = 0;
  // Stats de combat
  int initialAtk, atk, hp, maxHp = 1;
  // Placement de l'enemie
  float posX = width*0.45;
  float posY;
  float scaleX, scaleY = 100;
  int moneyDrop, expDrop;
  color white = color(255);
  color healthBar = color(0, 0, 0, 100);
  float healthHeight = 50;
  float healthOffset = 20+healthHeight;
  // Visualisation de l'enemie
  PImage sprite;
  // Collection de Data sur l'ennemie
  JSONArray enemies;
  JSONObject selectedEnemy;

  // Timer pour l'animation de mort en frames (30fps)
  float deathAnimTime = 2*30;

  // --------------------
  // CONSTRUCTOR
  // --------------------
  Enemy (int mobID) {
    // Juste avec l'ID, tout ce fait correctement attribuer selon le contenu JSON
    ID = mobID;
    enemies = loadJSONArray("./json/enemies.json");
    selectedEnemy = enemies.getJSONObject(ID);
    atk = selectedEnemy.getInt("attack");
    initialAtk = atk;
    maxHp = selectedEnemy.getInt("maxHp");
    hp = maxHp;
    scaleX = selectedEnemy.getFloat("scaleX");
    scaleY = selectedEnemy.getFloat("scaleY");
    moneyDrop = selectedEnemy.getInt("moneyDrop");
    expDrop = selectedEnemy.getInt("expDrop");
    posY = height*0.8-scaleY;
    sprite = loadImage(selectedEnemy.getString("sprite"));
  }

  // Affiche l'enemie
  void display(int mobIndex) {
    float maxScaleX = 150;
    float mobGutter = 25;
    float mobOffset = posX+(maxScaleX*mobIndex)+mobGutter*mobIndex;
    float hpDisplayConstrain = constrain(scaleX, 120, 150); // Pour pas que HP sort de son display
    image(sprite, mobOffset, posY, scaleX, scaleY);
    fill(healthBar);
    rect(mobOffset-((hpDisplayConstrain-scaleX)/2), posY-healthOffset, hpDisplayConstrain, healthHeight, 15);
    fill(white);
    textSize(24);
    textAlign(CENTER);
    text(hp+"/"+maxHp, mobOffset+scaleX/2, posY-healthOffset+healthHeight/3*2);
  }

  // Si l'ennemie est endommagé
  void hurt(int playerAttack) {
    hp -= playerAttack;
  }
  void hurt() {
    hp -= 1;
  }

  boolean deathCheck() {
    if (isDead()) {
      deathAnim();
      println("isDead");
    }
    return deathAnim();
  }

  // Check si l'enemi est mort
  boolean isDead() {
    if (hp <= 0) {
      hp = 0;
    }
    return (hp<=0);
  }
  // Séquence de mort
  boolean deathAnim() {
    if (scaleX > 0 && isDead()) {
      scaleX -= 150/deathAnimTime;
    }
    if (scaleY > 0 && isDead()) {
      scaleY -= 150/deathAnimTime;
    }
    return (scaleX <= 0 && scaleY <= 0);
  }

  void debuffedAtk(int debuffAmount) {
    floor(atk*(100/debuffAmount));
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
  int getMoneyDrop() { // Drop un montant d'argent un peu aléatoire
    return ceil(random(moneyDrop*0.9, moneyDrop*1.1));
  }
  int getExpDrop() { // Drop un montant d'exp un peu aléatoire
    return ceil(random(expDrop*0.9, expDrop*1.1));
  }
}
