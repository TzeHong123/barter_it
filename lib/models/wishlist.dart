class Wishlist {
  String? wishlistId;
  String? itemId;
  String? itemName;
  String? itemStatus;
  String? itemType;
  String? itemDesc;
  String? itemQty;
  String? wishlistQty;
  String? userId;
  String? ownerId;
  String? wishlistDate;

  Wishlist(
      {this.wishlistId,
      this.itemId,
      this.itemName,
      this.itemStatus,
      this.itemType,
      this.itemDesc,
      this.itemQty,
      this.wishlistQty,
      this.userId,
      this.ownerId,
      this.wishlistDate});

  Wishlist.fromJson(Map<String, dynamic> json) {
    wishlistId = json['wishlist_id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemStatus = json['item_status'];
    itemType = json['item_type'];
    itemDesc = json['item_desc'];
    itemQty = json['item_qty'];
    wishlistQty = json['wishlist_qty'];
    userId = json['user_id'];
    ownerId = json['owner_id'];
    wishlistDate = json['wishlist_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wishlist_id'] = wishlistId;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_status'] = itemStatus;
    data['item_type'] = itemType;
    data['item_desc'] = itemDesc;
    data['item_qty'] = itemQty;
    data['wishlist_qty'] = wishlistQty;
    data['user_id'] = userId;
    data['owner_id'] = ownerId;
    data['wishlist_date'] = wishlistDate;
    return data;
  }
}
