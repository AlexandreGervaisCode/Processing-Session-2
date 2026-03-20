class Inventory {
  int money = 0;
  int[] heldItemsArr;
  JSONArray allItems = loadJSONArray("./json/items.json");
  // --------------------
  // CONSTRUCTOR
  // --------------------
  Inventory (int m) {
    money = m;
  }
  
  void receiveItem(int itemID) {
    JSONObject gainedItem = allItems.getJSONObject(itemID);
    heldItemsArr = append(heldItemsArr, gainedItem.getInt("id"));
  }
  
  int getMoney() {
    return money;
  }
  
  int[] getHeldItems() {
    return heldItemsArr;
  }
}
