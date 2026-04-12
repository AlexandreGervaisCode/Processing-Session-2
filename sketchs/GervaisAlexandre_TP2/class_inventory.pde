class Inventory {
  int money;
  JSONArray itemsJsonFile;
  JSONObject emptyItem;
  JSONObject[] heldItemsArr;
  JSONObject[] allItems;
  PImage[] heldItemSprites;
  color itemHoverBubble;
  color itemHoverText;
  PImage itemFrame;
  Inventory() {
    money = 0;
    itemsJsonFile = loadJSONArray("json/items.json");
    heldItemsArr = new JSONObject[6];
    heldItemSprites = new PImage[6];
    itemHoverBubble = color(100, 100, 100, 170);
    itemHoverText = color(255, 255, 255);
    allItems = new JSONObject[61];
    itemFrame = loadImage("./menus/battle_item_frame.png");
  }

  void receiveItem(int itemID) {
    // JSONObject gainedItem = itemsJsonFile.getJSONObject(itemID);
    for (int i = 0; i < heldItemsArr.length; i++) {
      if (heldItemsArr[i] == emptyItem) {
        heldItemsArr[i] = allItems[itemID];
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
    float imageCenterY = startOffset + itemFrameBorder; // Centrer en Y

    for (int i = 0; i < heldItemsArr.length; i++) {
      if (heldItemsArr[i] != emptyItem) {
        float frameXPos = startOffset + (itemFrameSize*i) + (itemGutterSize*i);
        float imageCenterX = frameXPos + itemFrameBorder; // Centrer en X
        
        // L'item Frame vide
        image(itemFrame, frameXPos, startOffset, itemFrameSize, itemFrameSize);
        image(heldItemSprites[i], imageCenterX, imageCenterY);

        // Hover Check
        if (mouseX >= frameXPos && mouseX <= frameXPos+itemFrameSize && mouseY >= startOffset && mouseY <= startOffset+itemFrameSize) {
          float bubblePosX = frameXPos-itemFrameSize/2; // Position X de la desc
          float bubblePosY = itemFrameSize+startOffset*2; // Position Y de la desc
          float textOffset = 4; // Offset du text
          if (i == 0) {
            bubblePosX = frameXPos; // Position X de item 1
          }
          fill(itemHoverBubble);
          rect(bubblePosX, bubblePosY, itemFrameSize*2, itemFrameSize*1.2, 10);
          fill(itemHoverText);
          textSize(11);
          text(heldItemsArr[i].getString("name"), bubblePosX+textOffset/2, bubblePosY+textOffset/2, itemFrameSize*2-textOffset, itemFrameSize-textOffset-itemFrameSize/5*3);
          textSize(10);
          text(heldItemsArr[i].getString("desc"), bubblePosX+textOffset/2, bubblePosY+textOffset/2+itemFrameSize/5, itemFrameSize*2-textOffset, itemFrameSize-textOffset-itemFrameSize/10);
        }
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
        heldItemSprites[i-1] = heldItemSprites[i]; // Réduit l'index des sprites
        if (i == heldItemsArr.length-1) {
          heldItemsArr[i] = emptyItem; // Réduit la taille du tableau
          heldItemSprites[i] = loadImage(heldItemsArr[i].getString("sprite"));
        }
      }
    }
  }

  void initializeInventory() {
    // Crée un array facilement comparable avec tout dedans
    for (int i = 0; i < allItems.length; i++) {
      allItems[i] = itemsJsonFile.getJSONObject(i);
    }
    
    // Assigne une variable qui peut facilement checker si un inventory slot est vide
    emptyItem = allItems[0];
    
    // Crée l'inventaire en le remplissant d'éléments vides
    for (int i = 0; i < heldItemsArr.length; i++) {
      heldItemsArr[i] = emptyItem;
      heldItemSprites[i] = loadImage(heldItemsArr[i].getString("sprite"));
    }
  }

  JSONObject[] getHeldItems() {
    return heldItemsArr;
  }
  JSONObject[] getAllItems() {
    return allItems;
  }
}
