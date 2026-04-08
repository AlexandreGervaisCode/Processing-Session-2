class Player {
  // Valeurs par défaut
  int ID = 0;
  // Stats de combat
  int atk, def, hp, maxHp = 1;
  // Placement du joueur
  float posX = width/4;
  float posY = height/3*2;
  float scaleX = 150;
  float scaleY = 150;
  // Valeurs effets character-specific
  int critsOdd = 5; // Chance de coups critique sur 100
  int thorns, dodgeOdd, lifeSteal = 0;
  // Visualisation du Joueur
  PImage sprite = loadImage("heroes/pla_hero0.png");
  String name = "EMPTY";
  // Collection de Data sur le héro
  JSONArray heroes = loadJSONArray("./json/heroes.json");
  JSONObject selectedHero = heroes.getJSONObject(0);
  // --------------------
  // CONSTRUCTOR
  // --------------------
  Player (int heroID) {
    ID = heroID;
    selectedHero = heroes.getJSONObject(ID);
    atk = selectedHero.getInt("attack");
    def = selectedHero.getInt("defense");
    maxHp = selectedHero.getInt("maxHp");
    hp = maxHp;
    scaleX = selectedHero.getFloat("scaleX");
    scaleY = selectedHero.getFloat("scaleY");
    sprite = loadImage(selectedHero.getString("sprite"));
    name = selectedHero.getString("name");
    // Bonus character-specific
    critsOdd = selectedHero.getInt("critsOdd");
    thorns = selectedHero.getInt("thorns");
    dodgeOdd = selectedHero.getInt("dodgeOdd");
    lifeSteal = selectedHero.getInt("lifeSteal");
  }

  // Affiche le joueur
  void display() {
    image(sprite, posX, posY, scaleX, scaleY);
  }

  // Si le joueur est endommagé
  void hurt(Enemy mobAttack) {
    hp -= mobAttack.getAtk();
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
  String getName() {
    return name;
  }
  int getID() {
    return ID;
  }
}
