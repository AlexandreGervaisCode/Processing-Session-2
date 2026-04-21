class Shop {
  int itemAmount;
  int boosterAmount;
  int cardAmount;
  JSONArray itemsJsonFile;

  JSONObject[] itemsArr;
  JSONObject[] cardsArr;
  ArrayList<JSONObject> allItems;

  // CONSTRUCTOR
  Shop () {
    itemsJsonFile = loadJSONArray("json/items.json");
    itemAmount = 4;
    boosterAmount = 1;
    cardAmount = 3;
    itemsArr = new JSONObject[itemAmount];
    cardsArr = new JSONObject[cardAmount];
    allItems = new ArrayList<JSONObject>();
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
    for (int i = 0; i < itemsArr.length; i++) {
      itemsArr[i] = allItems.get(i);
      println(itemsArr[i].getString("name"));
    }
  }
  
  // Affiche le shop
  void display(Inventory bag, Player hero) {
    bag.itemDisplay();
    hero.statsDisplay();
  }
}
