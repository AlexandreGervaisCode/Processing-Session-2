class Enemy {
  int ID = 0;
  // Stats de combat
  int initialAtk, atk, def, hp, maxHp = 1;
  int block = 0;
  // Placement de l'enemie
  float posX = width*0.45;
  float posY;
  float scaleX, scaleY = 100;
  int moneyDrop, expDrop;
  color white = color(255);
  color colTargeted = color(255, 0, 0, 170);
  color healthBar = color(0, 0, 0, 100);
  color blockColor = color(0);
  float healthHeight = 50;
  float healthOffset = 20+healthHeight;
  // Visualisation de l'enemie
  PImage sprite;
  // Block sprite
  PImage shieldIcon;
  float shieldIconSize = 40;
  // Collection de Data sur l'ennemie
  JSONArray enemies;
  JSONObject selectedEnemy;

  // Timer pour l'animation de mort en frames (30fps)
  float deathAnimTime = 2*30;

  // Sert à déterminer l'action dont l'evnemies va faire ce tour-ci
  int enemyAction = 0;
  // Quelle position que l'ennemie occupe
  float mobOffset;
  int enemyArrayCurrentIndex;

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
    def = selectedEnemy.getInt("defense");
    maxHp = selectedEnemy.getInt("maxHp");
    hp = maxHp;
    scaleX = selectedEnemy.getFloat("scaleX");
    scaleY = selectedEnemy.getFloat("scaleY");
    moneyDrop = selectedEnemy.getInt("moneyDrop");
    expDrop = selectedEnemy.getInt("expDrop");
    posY = height*0.7-scaleY;
    sprite = loadImage(selectedEnemy.getString("sprite"));
    shieldIcon = loadImage("menus/battle_icon_shield.png");
  }

  // Affiche l'enemie
  void display(int mobIndex, boolean isTarget, int mobTargetedIndex, boolean isAbilitySelected) {
    float maxScaleX = 150;
    float mobGutter = 25;
    mobOffset = posX+(maxScaleX*mobIndex)+mobGutter*mobIndex;
    float hpDisplayConstrain = constrain(scaleX, 120, maxScaleX); // Pour pas que HP sort de son display
    image(sprite, mobOffset, posY, scaleX, scaleY);
    enemyArrayCurrentIndex = mobIndex;
    if (hp > 0) {
      fill(healthBar);
      rect(mobOffset-((hpDisplayConstrain-scaleX)/2), posY-healthOffset, hpDisplayConstrain, healthHeight, 15);
      fill(white);
      textSize(24);
      textAlign(CENTER);
      text(hp+"/"+maxHp, mobOffset+scaleX/2, posY-healthOffset+healthHeight/3*2);

      // Affiche l'action prochaine de l'ennemie
      if (enemyAction == 0) {
        text("ATK " + atk, mobOffset+scaleX/2, posY-healthOffset-healthHeight/3);
      } else if (enemyAction == 1) {
        text("DEF " + def, mobOffset+scaleX/2, posY-healthOffset-healthHeight/3);
      }

      if (block > 0) {
        image(shieldIcon, mobOffset-((hpDisplayConstrain-scaleX)/2)-shieldIconSize/2, posY-healthOffset-shieldIconSize/2, shieldIconSize, shieldIconSize);
        textSize(12);
        fill(blockColor);
        text(block, mobOffset-((hpDisplayConstrain-scaleX)/2), posY-healthOffset);
      }

      // Affiche si l'ennemie est ciblé
      if (isMobHovered() && mobIndex == mobTargetedIndex && isAbilitySelected && isTarget) {
        stroke(colTargeted);
        strokeWeight(8);
        noFill();
        circle(mobOffset+scaleX/2, posY+scaleY/2, scaleX*1.2);
        noStroke();
      }
    }
  }

  boolean isMobHovered() {
    return (mouseX >= mobOffset && mouseX <= mobOffset+scaleX && mouseY >= posY && mouseY <= posY+scaleY);
  }

  // Si l'ennemie est endommagé
  void hurt(int playerAttack) {
    if (playerAttack - block > 0) {
      hp -= (playerAttack - block);
    }
    block -= playerAttack;
    if (block < 0) {
      block = 0;
    }
  }
  void hurt() {
    hp -= 1;
  }

  // Check si l'animation de mort est terminée
  boolean deathCheck() {
    if (isDead()) {
      deathAnim();
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

  // Si une abilité de réduction d'atk est utilisé sur lui
  void debuffedAtk(int debuffAmount) {
    atk = floor(atk*debuffAmount/100);
  }

  // Retourne les stats
  int getAtk() {
    return atk;
  }
  int getHP() {
    return hp;
  }
  int getMaxHP() {
    return maxHp;
  }
  int getBlock() {
    return block;
  }
  void turnEnd() { // Reset les stats à la fin du tour
    atk = initialAtk;
    block = 0;
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
  int selectAction() { // Sélectionne s'il attaque ou défend ce tour
    enemyAction = floor(random(2));
    return enemyAction;
  }
  int getEnemyArrayCurrentIndex() {
    return enemyArrayCurrentIndex;
  }
  void increaseBlock() { // Si l'ennemi défend ce tour ci
    block += def;
  }
}
