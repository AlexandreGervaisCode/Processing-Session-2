class Player {
  // Valeurs par défaut
  int ID = 0;
  // Stats de combat
  int atk, maxAtk, def, maxDef, hp, maxHp = 1;
  // Placement du joueur
  float posX = 60;
  float posY;
  float scaleX = 300;
  float scaleY = 250;
  color white = color(255);
  color healthBar = color(0, 0, 0, 100);
  color blockColor = color(0);
  float healthHeight = 50;
  float healthOffset = 20+healthHeight;
  // Valeurs effets character-specific
  int critsOdd = 5; // Chance de coups critique sur 100
  int thorns, dodgeOdd, lifeSteal = 0;
  // Visualisation du Joueur
  PImage sprite;
  String name = "EMPTY";
  // Block sprite
  PImage shieldIcon;
  float shieldIconSize = 40;
  // Collection de Data sur le héro
  JSONArray heroes;
  JSONObject selectedHero;
  // --------------------
  // CONSTRUCTOR
  // --------------------
  Player (int heroID) {
    heroes = loadJSONArray("./json/heroes.json");
    ID = heroID;
    selectedHero = heroes.getJSONObject(ID);
    atk = selectedHero.getInt("attack");
    maxAtk = atk;
    def = selectedHero.getInt("defense");
    maxDef = def;
    maxHp = selectedHero.getInt("maxHp");
    hp = maxHp;
    scaleX = selectedHero.getFloat("scaleX");
    scaleY = selectedHero.getFloat("scaleY");
    posY = height*0.75-scaleY;
    sprite = loadImage(selectedHero.getString("sprite"));
    name = selectedHero.getString("name");
    shieldIcon = loadImage("menus/battle_icon_shield.png");
    // Bonus character-specific
    critsOdd = selectedHero.getInt("critsOdd");
    thorns = selectedHero.getInt("thorns");
    dodgeOdd = selectedHero.getInt("dodgeOdd");
    lifeSteal = selectedHero.getInt("lifeSteal");
  }

  // Affiche le joueur
  void display(int blockAmount) {
    image(sprite, posX, posY, scaleX, scaleY);
    fill(healthBar);
    rect(posX+scaleX/4, posY-healthOffset, scaleX/2, healthHeight, 15);
    fill(white);
    textSize(24);
    textAlign(CENTER);
    text(hp+"/"+maxHp, posX+scaleX/2, posY-healthOffset+healthHeight/3*2);
    
    if (blockAmount > 0) {
      image(shieldIcon, posX+scaleX/4-shieldIconSize/2, posY-healthOffset-shieldIconSize/2, shieldIconSize, shieldIconSize);
      textSize(12);
      fill(blockColor);
      text(blockAmount, posX+scaleX/4, posY-healthOffset);
    }
  }

  // Si le joueur est endommagé
  void hurt(int leftOverDamage) {
      hp -= leftOverDamage;
    if (isDead()) {
      deathAnim();
    }
  }
  void recoil(int recoil) {
    hp -= ceil(maxHp/(100/recoil));
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
  
  // Montre les stats
  void statsDisplay() {
    fill(healthBar);
    float statOffsetX = 20;
    float statOffsetY = 10;
    float statsStringY = 20;
    float stringOffset = 10; // Pour éviter que le text soit coller au bordures
    String statString = "ATK:"+atk+" DEF:"+def+" Crits:"+critsOdd+"%";
    rect(width/2+statOffsetX, statOffsetY, width/4, height/8, 15);
    if (thorns > 0) {
      statString += " Thorns:"+thorns;
    }
    if (dodgeOdd > 0) {
      statString += " Dodge:"+dodgeOdd+"%";
    }
    fill(white);
    textSize(16);
    textAlign(CENTER);
    text("STATS", width/2+statOffsetX, statOffsetY+stringOffset, width/4-stringOffset, height/10-stringOffset);
    text(statString, width/2+statOffsetX, statOffsetY+stringOffset+statsStringY, width/4-stringOffset, height/10-stringOffset);
  }

  // Retourne les stats
  int getAtk() {
    return atk;
  }
  int getDef() {
    return def;
  }
  int getHP() {
    return hp;
  }
  int getMaxHP() {
    return maxHp;
  }
  void resetAtk() {
    atk = maxAtk;
  }
  String getName() {
    return name;
  }
  int getID() {
    return ID;
  }
  JSONObject getSelectedHero() {
    return selectedHero;
  }
  int getCritsOdd() {
    return critsOdd;
  }
  int getThorns() {
    return thorns;
  }
  int getDodgeOdd() {
    return dodgeOdd;
  }
  int getLifeSteal() {
    return lifeSteal;
  }
}
