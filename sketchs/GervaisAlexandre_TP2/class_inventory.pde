class Inventory {
  int money = 0;
  JSONArray allItems = loadJSONArray("json/items.json");
  JSONObject emptyItem;
  JSONObject[] heldItemsArr = new JSONObject[6];
  PImage[] heldItemSprites = new PImage[6];

  void receiveItem(int itemID) {
    // JSONObject gainedItem = allItems.getJSONObject(itemID);
    for (int i = 0; i < heldItemsArr.length; i++) {
      if (heldItemsArr[i] == emptyItem) {
        heldItemsArr[i] = allItems.getJSONObject(itemID);
        heldItemSprites[i] = loadImage(heldItemsArr[i].getString("sprite"));
        i = heldItemsArr.length;
      }
    }
  }

  int getMoney() {
    return money;
  }

  void gainMoney(int amount) {
    money += amount;
  }

  void loseMoney(int amount) {
    money -= amount;
  }

  void itemDisplay() {
    float itemFrameSize = 76; // Taille du frame des items
    float startOffset = 10; // Le offset (posX posY) du premier item frame
    float itemGutterSize = 7; // L'espace entre chaque items
    float itemFrameBorder = 6; // Taille de la bordure du item frame
    float imageCenterY = startOffset - itemFrameBorder; // Centrer en Y

    for (int i = 0; i < heldItemsArr.length; i++) {
      if (heldItemsArr[i] != emptyItem) {
        float frameXPos = startOffset + (itemFrameSize*i) + (itemGutterSize*i);
        float imageCenterX = frameXPos - itemFrameBorder; // Centrer en X
        // À Remplacer fill() et square() une fois que l'itemframe asset est fait
        // image(itemFrame, heldItemsArr, startOffset, itemFrameSize, itemFrameSize);
        fill(179, 127, 86);
        square(frameXPos, startOffset, itemFrameSize);
        image(heldItemSprites[i], imageCenterX, imageCenterY);
      }
    }
  }

  void loseHeldItem(int itemIndex) {
    boolean elementRemoved = false;
    for (int i = 0; i < heldItemsArr.length; i++) {
      if (i == itemIndex) { // Si l'objet est celui enlevé, enlève-le
        elementRemoved = true;
      } else if (elementRemoved) { // Si l'index de l'objet viens après celui enlevé
        heldItemsArr[i-1] = heldItemsArr[i]; // Réduit l'index des objets
        if (i == heldItemsArr.length-1) {
          heldItemsArr[i] = emptyItem; // Réduit la taille du tableau
          heldItemSprites[i] = loadImage(heldItemsArr[i].getString("sprite"));
        }
      }
    }
  }

  void initializeInventory() {
    emptyItem = allItems.getJSONObject(0);
    for (int i = 0; i < heldItemsArr.length; i++) {
      heldItemsArr[i] = emptyItem;
      heldItemSprites[i] = loadImage(heldItemsArr[i].getString("sprite"));
    }
  }

  JSONObject[] getHeldItems() {
    return heldItemsArr;
  }
}
