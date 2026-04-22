class Shop {
  // Nombre d'éléments
  int itemAmount;
  int boosterAmount; // PAS AJOUTÉ
  int cardAmount; // PAS AJOUTÉ

  // Fichiers à loader
  PImage itemFrame;
  JSONArray itemsJsonFile;

  // Arrays
  JSONObject[] itemsArr;
  PImage[] itemImgArr;
  JSONObject[] cardsArr;
  ArrayList<JSONObject> allItems;

  // Couleurs
  color itemHoverBubble;
  color itemHoverText;
  color itemPriceCol;
  color background;
  color itemContainer;

  // CONSTRUCTOR
  Shop () {
    itemsJsonFile = loadJSONArray("json/items.json");
    itemAmount = 4;
    boosterAmount = 1;
    cardAmount = 3;
    itemFrame = loadImage("menus/battle_item_frame.png");
    itemsArr = new JSONObject[itemAmount];
    itemImgArr = new PImage[itemAmount];
    cardsArr = new JSONObject[cardAmount];
    allItems = new ArrayList<JSONObject>();

    itemHoverBubble = color(100, 100, 100, 170);
    itemHoverText = color(255, 255, 255);
    itemPriceCol = color(232, 226, 44);
    background = color(82, 193, 86);
    itemContainer = color(107, 77, 131);
  }

  // Fait apparaitre le shop
  void loadShop(Inventory bag) {
    JSONObject[] heldItemsArr;
    heldItemsArr = new JSONObject[6];
    heldItemsArr = bag.getHeldItems();
    for (int i = 1; i < itemsJsonFile.size(); i++) {
      allItems.add(itemsJsonFile.getJSONObject(i));
    }

    // Enlève les objets obtenu du pool d'objets
    for (int i = 0; i < heldItemsArr.length; i++) {
      if (heldItemsArr[i].getInt("id") != 0) { // Si l'item n'est pas empty
        for (int j = 0; j < allItems.size(); j++) {
          if (heldItemsArr[i] == allItems.get(j)) { // Enlève l'item en question
            allItems.remove(j);
          }
        }
      }
    }
    Collections.shuffle(allItems);
    for (int i = 0; i < itemsArr.length; i++) { // Ajoute les objets pour le shop
      itemsArr[i] = allItems.get(i);
      itemImgArr[i] = loadImage(itemsArr[i].getString("sprite"));
    }
  }

  // Affiche le shop
  void display(Inventory bag) {
    background(background);
    fill(itemContainer);
    rect(width*0.15, height*0.35, width*0.7, height*0.3);
    
    bag.itemDisplay();

    for (int i = 0; i < itemsArr.length; i++) { // Affiche chaque items
      float posX = width/5+(175*i);
      float posY = height*0.45;
      float itemFrameSize = 76; // Taille du frame des items
      float itemFrameBorder = 6; // Taille de la bordure du item frame
      float imageCenterX = posX + itemFrameBorder; // Centrer en Y
      float imageCenterY = posY + itemFrameBorder; // Centrer en Y

      // Images
      image(itemFrame, posX, posY, itemFrameSize, itemFrameSize);
      image(itemImgArr[i], imageCenterX, imageCenterY);

      // Bulle pour le prix
      fill(itemHoverBubble);
      rect(posX, posY+itemFrameSize+itemFrameBorder, itemFrameSize, itemFrameSize/4);

      // Le prix
      textAlign(CENTER);
      textSize(14);
      fill(itemPriceCol);
      text("$"+itemsArr[i].getInt("price"), posX+itemFrameSize/2, posY+itemFrameSize+itemFrameBorder+itemFrameSize/6);

      // Si l'objet est survolé
      if (mouseX >= posX && mouseX <= posX+itemFrameSize && mouseY >= posY && mouseY <= posY+itemFrameSize) {
        float bubblePosX = posX-itemFrameSize/2; // Position X de la desc
        float bubblePosY = itemFrameSize+posY*1.1; // Position Y de la desc
        float textOffset = 4; // Offset du text
        
        // Bulle de description
        fill(itemHoverBubble);
        rect(bubblePosX, bubblePosY, itemFrameSize*2, itemFrameSize*1.2, 10);
        fill(itemHoverText);
        textSize(11);
        text(itemsArr[i].getString("name"), bubblePosX+textOffset/2, bubblePosY+textOffset/2, itemFrameSize*2-textOffset, itemFrameSize-textOffset-itemFrameSize/5*3);
        textSize(10);
        text(itemsArr[i].getString("desc"), bubblePosX+textOffset/2, bubblePosY+textOffset/2+itemFrameSize/5, itemFrameSize*2-textOffset, itemFrameSize-textOffset-itemFrameSize/10);
        
        // Si l'utilisateur tente d'acheter un objet
        if (mousePressed && bag.getMoney() >= itemsArr[i].getInt("price")) {
          bag.loseMoney(itemsArr[i].getInt("price"));
          bag.receiveItem(itemsArr[i].getInt("id"));
        }
      }
    }
  }
}
