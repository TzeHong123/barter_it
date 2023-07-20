class RecordDetails {
  String? recorddetailId;
  //String? recordBill;
  String? itemId;
  String? itemName;
  String? recorddetailQty;
  String? recorddetailPaid;
  String? traderId;
  String? ownerId;
  String? recorddetailDate;

  RecordDetails(
      {this.recorddetailId,
      //this.recordBill,
      this.itemId,
      this.itemName,
      this.recorddetailQty,
      this.recorddetailPaid,
      this.traderId,
      this.ownerId,
      this.recorddetailDate});

  RecordDetails.fromJson(Map<String, dynamic> json) {
    recorddetailId = json['recorddetail_id'];
    //recordBill = json['record_bill'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    recorddetailQty = json['recorddetail_qty'];
    recorddetailPaid = json['recorddetail_paid'];
    traderId = json['trader_id'];
    ownerId = json['owner_id'];
    recorddetailDate = json['recorddetail_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recorddetail_id'] = recorddetailId;
    //data['record_bill'] = recordBill;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['recorddetail_qty'] = recorddetailQty;
    data['recorddetail_paid'] = recorddetailPaid;
    data['trader_id'] = traderId;
    data['owner_id'] = ownerId;
    data['recorddetail_date'] = recorddetailDate;
    return data;
  }
}
